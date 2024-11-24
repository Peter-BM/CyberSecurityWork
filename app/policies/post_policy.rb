class PostPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.present? 
  end

  def update?
    user.present? && user == record.user 
  end

  def destroy?
    user.present? && user == record.user
  end
end
