require 'yaml'
class ChecklistsController < ApplicationController
	# GET /checklists
	# GET /checklists.xml
	def index
		@checklists = Checklist.all(:select=>'id,list,title,updated_at',:order=>'updated_at DESC')
		
		@checklists = Checklist.prepare_lists @checklists
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml { render :xml => @checklists }
		end
	end
  
	# what happens when a user checks off a checklist item
	def checkoff
		if request.xhr?
			# Events we need to capture: start a new instance, update existing instance, email complete!
			
			# Event: Start a new instance
			# an instance of the checklist is one that is filled out by this user, isn't complete, and is the most recent
			# they will only have one active instance at any time
			# if it doesn't exist, create it			
			instance = Instance.get_or_create params[:id]
			
			# Update what item was just checked or checked off
			instance.finished_items = Instance.update_finished_items instance.id, instance.finished_items, params[:item]			
			
			respond_to do |format|
				format.json { render :json => instance }
			end
		end
	end
	
	# when all items done, they can finish it
	def finish		
		instance = Instance.get_or_create params[:id]
		title = Checklist.get_title_from_list instance.list
		
		# send email
		instance.emails.split(',').each do |email|
			email.strip!
			Notifier.checklist_finished(title, email).deliver if Checklist.is_email email
		end
		
		# mark as finished
		Instance.finish Instance.get_or_create params[:id]
		
		# send em!
		flash[:success] = 'We emailed your team (' + instance.emails + ') to let them know the checklist was completed.'
		redirect_to checklists_path
	end

	# GET /checklists/1
	# GET /checklists/1.xml
	def show
		# load up the checklist in question, which we have
		@checklist = Checklist.prepare_list Checklist.find params[:id]
		
		# pull any previous instances to show to the user in a history
		@previous = Instance.get_previous params[:id]
		
		# get an instance if we have one
		@instance = Instance.exists params[:id]
		@instance = @instance ? (Checklist.prepare_list @instance) : @instance;
		
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @checklist }
		end
	end
	
	# if filling out an instance you can just give up
	def abandon
		@checklist = Checklist.find params[:id]
		@instance = Instance.get_or_create params[:id]
		@instance.destroy
		
		respond_to do |format|
			format.html { redirect_to(@checklist) }
			format.xml  { head :ok }
		end
	end

	# GET /checklists/new
	# GET /checklists/new.xml
	def new
		@checklist = Checklist.new
		
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @checklist }
		end
	end

	# GET /checklists/1/edit
	def edit
		@checklist = Checklist.find(params[:id])
	end

	# POST /checklists
	# POST /checklists.xml
	def create
		@checklist = Checklist.new(params[:checklist])
		
		respond_to do |format|
			if @checklist.save
				flash[:success] = 'Your checklist was created!'
				format.html { redirect_to(@checklist) }
				format.xml  { render :xml => @checklist, :status => :created, :location => @checklist }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @checklist.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /checklists/1
	# PUT /checklists/1.xml
	def update
		@checklist = Checklist.find(params[:id])
		
		# we take the first line and make that the title
		params[:checklist][:title] = Checklist.get_title_from_list params[:checklist][:list]
		
		# we take thelast line to get the email recipients
		params[:checklist][:emails] = Checklist.get_emails_from_list params[:checklist][:list]
		
		respond_to do |format|
			if @checklist.update_attributes(params[:checklist])
				flash[:success] = 'Your checklist template was saved.'
				format.html { redirect_to(@checklist) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @checklist.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /checklists/1
	# DELETE /checklists/1.xml
	def destroy
		@checklist = Checklist.find(params[:id])
		@checklist.destroy
		
		respond_to do |format|
			format.html { redirect_to(checklists_url) }
			format.xml  { head :ok }
		end
	end
end