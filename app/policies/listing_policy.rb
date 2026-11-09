class ListingPolicy < BasePolicy
  def index?
    true
  end

  def show?
    record.published? || owner? || moderator?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    owner? || moderator?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def publish?
    update?
  end

  def withdraw?
    update?
  end

  def mark_rented?
    update?
  end

  class Scope < BasePolicy::Scope
    def resolve
      return scope.all if user&.moderator?

      if user
        scope.where(status: :published)
             .or(scope.where(property_id: user.properties.select(:id)))
      else
        scope.where(status: :published)
      end
    end
  end

  private

  def owner?
    user.present? &&
      record.property.present? &&
      record.property.user_id == user.id
  end

  def moderator?
    user&.moderator? || false
  end
end
