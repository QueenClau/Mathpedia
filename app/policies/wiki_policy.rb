class WikiPolicy < ApplicationPolicy
	attr_reader :user, :wiki

	def initialize(user, wiki)
		@user = user
		@wiki = wiki
	end 

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
		(user.admin? || @wiki.user == user) && user != nil
	end 

	def edit?
		update?
	end 

	def destroy?
		(user.admin? || @wiki.user == user) && user != nil
	end 

	def wiki
		record
	end 

	 class Scope
	     attr_reader :user, :scope
	 
	     def initialize(user, scope)
	       @user = user
	       @scope = scope
	     end
	 
	     def resolve
		   if user.admin?
	         scope.all # if the user is an admin, show them all the wikis
	       elsif user.premium?
	         scope.public | user.wikis |user.shared.wikis
	       else # this is the lowly standard user
	         scope.public
	       end
	       # wikis = []
	       # if user.role == 'admin'
	       #   wikis = scope.all # if the user is an admin, show them all the wikis
	       # elsif user.role == 'premium'
	       #   all_wikis = scope.all
	       #   all_wikis.each do |wiki|
	       #     if not wiki.private? || wiki.owner == user || wiki.collaborations.include?(user)
	       #       wikis << wiki # if the user is premium, only show them public wikis, or that private wikis they created, or private wikis they are a collaborator on
	       #     end
	       #   end
	       # else # this is the lowly standard user
	       #   all_wikis = scope.all
	       #   wikis = []
	       #   all_wikis.each do |wiki|
	       #     if not wiki.private? || wiki.collaborations.include?(user)
	       #       wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
	       #     end
	       #   end
	       # end
	       # wikis # return the wikis array we've built up
	     end
	   end
	
end 