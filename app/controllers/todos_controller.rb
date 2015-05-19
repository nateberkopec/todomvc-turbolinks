class TodosController < ApplicationController
  # GET /todos
  def index
    @todos = Todo.all.order(created_at: :asc)

    filtering_params.each do |key, value|
      @todos = @todos.public_send(key, value) if value.present?
    end
  end

  # POST /todos
  def create
    Todo.create(todo_params)
    redirect_to todos_url
  end

  # PATCH/PUT /todos/1
  def update
    # cheat - sometimes the blur event handler asks to update an already destroyed record.
    todo = Todo.find_by(id: params[:id]).try(:update, todo_params)
    redirect_to todos_url
  end

  def update_many
    Todo.where(id: params[:ids]).update(todo_params)
    redirect_to todos_url
  end

  # DELETE /todos/1
  def destroy
    # same problem as on update - sometimes we try to destroy twice in the JS
    Todo.find_by(id: params[:id]).try(:destroy)
    redirect_to todos_url
  end

  def destroy_many
    Todo.where(id: params[:ids]).try(:destroy_all)
    redirect_to todos_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :is_completed)
    end

    def filtering_params
      params.slice(:completed)
    end
    helper_method :filtering_params
end
