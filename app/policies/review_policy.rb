class ReviewPolicy < BasePolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    return false unless user&.member?
    return false unless record.visit

    visit = record.visit

    visit.completed? &&
      visit.application.user_id == user.id &&
      !visit.review.present?
  end

  def new?
    user&.member? || false
  end

  def update?
    author?
  end

  def edit?
    update?
  end

  def destroy?
    author? || moderator?
  end

  class Scope < BasePolicy::Scope
    def resolve
      scope.all
    end
  end

  private

  def author?
    user.present? && record.user_id == user.id
  end

  def moderator?
    user&.moderator? || false
  end
end
