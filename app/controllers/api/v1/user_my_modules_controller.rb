# frozen_string_literal: true

module Api
  module V1
    class UserMyModulesController < BaseController
      before_action :load_team
      before_action :load_project
      before_action :load_experiment
      before_action :load_task
      before_action :load_user_task, only: :show

      def index
        user_tasks = @my_module.user_my_modules
                               .page(params.dig(:page, :number))
                               .per(params.dig(:page, :size))

        render jsonapi: user_tasks,
          each_serializer: UserMyModuleSerializer
      end

      def show
        render jsonapi: @user_task, serializer: UserMyModuleSerializer
      end

      private

      def load_team
        @team = Team.find(params.require(:team_id))
        render jsonapi: {}, status: :forbidden unless can_read_team?(@team)
      end

      def load_project
        @project = @team.projects.find(params.require(:project_id))
        render jsonapi: {}, status: :forbidden unless can_read_project?(
          @project
        )
      end

      def load_experiment
        @experiment = @project.experiments.find(params.require(:experiment_id))
        render jsonapi: {}, status: :forbidden unless can_read_experiment?(
          @experiment
        )
      end

      def load_task
        @my_module = @experiment.my_modules.find(params.require(:task_id))
      end

      def load_user_task
        @user_task = @my_module.user_my_modules.find(
          params.require(:id)
        )
      end
    end
  end
end