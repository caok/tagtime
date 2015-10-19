module Apis
  class IssuesController < BaseController 
    before_action :break_tag, only: [:create]

    def index 
      @issues = Issue.all.last(10)
      render file: 'issues/index.json.jbuilder'
    end 

    def create
      unless is_correct_tag?
        render json: { type: "fail", message: "Invalid tagtime format!" } 
      end

      tag_params = generate_params
      issue =  Issue.new(tag_params)

      if issue.save
        render json: { type: "success", message: "created new issue tag!" }
      else
        render json: { type: "fail", message: "failed to create issue tag!" }
      end
    end

    private
    attr_reader :tags

    def generate_params 
      ActionController::Parameters.new(number: tags[0], spend_hour: tags[1], spend_minutes: tags[2]).permit!
    end

    def is_correct_tag?
      tags && tags.compact.length == 3
    end

    def break_tag
      ele = params[:tag] && params[:tag].split(':') 
      return nil if ele.count != 3

      number = (ele[0] =~ /#(\d+)/ ? ele[0].match(/#(\d+)/)[1] : nil)
      hours = (ele[1] =~ /(\d+)h/ ? ele[1].match(/(\d+)h/)[1] : nil)
      minutes = (ele[2] =~ /(\d+)m/ ? ele[2].match(/(\d+)m/)[1] : nil) 
      @tags = [number, hours, minutes]
    end
  end
end
