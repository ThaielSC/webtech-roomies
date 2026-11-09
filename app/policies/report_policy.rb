class ReportPolicy < BasePolicy
  def index?
    moderator?
  end

  def show?
    moderator? || author?
  end

  def create?
    user.present? && record.listing.present?
  end

  def new?
    user.present?
  end

  def review?
    moderator?
  end

  def dismiss?
    moderator?
  end

  def take_action?
    moderator?
  end

  class Scope < BasePolicy::Scope
    def resolve
      return scope.none unless user
      return scope.all if user.moderator?

      scope.where(user_id: user.id)
    end
  end

  private

  def moderator?
    user&.moderator? || false
  end

  def author?
    user.present? && record.user_id == user.id
  end
end
