class TodosController < ApplicationController
  # GET /todos
  def index
    @todos = Todo.all.order(created_at: :asc)
  end

  # POST /todos
  def create
    Todo.create(todo_params)
    redirect_to todos_url
  end

  # PATCH/PUT /todos/1
  def update
    todo = Todo.find_by(id: params[:id])
    # cheat - sometimes the blur event handler asks to update an already destroyed record.
    todo.try(:update, todo_params)
    redirect_to todos_url
  end

  def update_many
    Todo.where(id: params[:ids]).update(todo_params)
    redirect_to todos_url
  end

  # DELETE /todos/1
  def destroy
    Todo.find(params[:id]).destroy
    redirect_to todos_url
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :is_completed)
    end
end
