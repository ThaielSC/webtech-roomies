class VisitPolicy < BasePolicy
  def index?
    user.present?
  end

  def show?
    participant?
  end

  def create?
    participant? && record.application.shortlisted?
  end

  def new?
    user.present?
  end

  def update?
    participant? && record.proposed?
  end

  def edit?
    update?
  end

  def destroy?
    participant? && record.proposed?
  end

  def confirm?
    participant? && record.proposed?
  end

  def cancel?
    participant? && (record.proposed? || record.confirmed?)
  end

  def complete?
    participant? && record.confirmed?
  end

  class Scope < BasePolicy::Scope
    def resolve
      return scope.none unless user

      scope.joins(application: { listing: :property })
           .where(
             "applications.user_id = :user_id OR properties.user_id = :user_id",
             user_id: user.id
           )
    end
  end

  private

  def participant?
    return false unless user && record.application

    application = record.application

    application.user_id == user.id ||
      application.listing.property.user_id == user.id
  end
end
