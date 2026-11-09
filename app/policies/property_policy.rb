class PropertyPolicy < BasePolicy
  def index?
    true
  end

  def show?
    true
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

  class Scope < BasePolicy::Scope
    def resolve
      scope.all
    end
  end

  private

  def owner?
    user.present? && record.user_id == user.id
  end

  def moderator?
    user&.moderator? || false
  end
end
