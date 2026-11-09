class ApplicationPolicy < BasePolicy
  def index?
    user.present?
  end

  def show?
    applicant? || host? || moderator?
  end

  def create?
    user.present? &&
      record.listing.present? &&
      record.listing.published? &&
      !host?
  end

  def new?
    create?
  end

  def update?
    applicant? && record.pending?
  end

  def edit?
    update?
  end

  def destroy?
    applicant? && (record.pending? || record.shortlisted?)
  end

  def shortlist?
    host?
  end

  def reject?
    host?
  end

  def accept?
    host?
  end

  class Scope < BasePolicy::Scope
    def resolve
      return scope.none unless user

      return scope.all if user.moderator?

      scope.left_joins(listing: :property)
        .where(
          "applications.user_id = :user_id OR properties.user_id = :user_id",
          user_id: user.id
        )
    end
  end

  private

  def applicant?
    user.present? && record.user_id == user.id
  end

  def host?
    user.present? &&
      record.listing.present? &&
      record.listing.property.user_id == user.id
  end

  def moderator?
    user&.moderator? || false
  end
end
