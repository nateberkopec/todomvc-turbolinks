require 'test_helper'

class TodoMvcTest < ActionDispatch::IntegrationTest
  def setup
    require_js
    visit "/"
  end

  test "When page is initially opened it should focus on the todo input field" do
    assert_equal "new-todo", page.evaluate_script('document.activeElement.id')
  end

  test "When no todos, should hide #main and #footer" do
    assert_equal 0, todo_items.size
    refute page.has_selector?("#main")
    refute page.has_selector?("#footer")
  end

  test "allow me to add todo items" do
    enter_item(TODO_ITEM_ONE)
    assert_items [TODO_ITEM_ONE]

    enter_item(TODO_ITEM_TWO)
    assert_items [TODO_ITEM_ONE, TODO_ITEM_TWO]
  end

  test "clear text input field when an item is added" do
    enter_item(TODO_ITEM_ONE)
    assert_equal "", find("#new-todo").text
  end

  test "append new items to the bottom of the list" do
    create_standard_items
    assert_equal 3, todo_items.size
    assert_equal TODO_ITEM_ONE, todo_items[0].text
    assert_equal TODO_ITEM_TWO, todo_items[1].text
    assert_equal TODO_ITEM_THREE, todo_items[2].text
  end

  test "trim text input" do
    enter_item('   ' + TODO_ITEM_ONE + '  ')
    assert_equal TODO_ITEM_ONE, todo_items[0].text
  end

  test "should show #main and #footer when items added" do
    enter_item(TODO_ITEM_ONE)

    assert page.has_selector?("#main")
    assert page.has_selector?("#footer")
  end

  test "allow me to mark all items as completed" do
    create_standard_items

    find('#toggle-all').click

    assert todo_items.all? { |el| el[:class] == "completed" }
  end

  private

  def assert_items(ary)
    assert_equal ary, todo_items.map { |el| el.find(".view label").text }
  end

  TODO_ITEM_ONE = 'buy some cheese'
  TODO_ITEM_TWO = 'feed the cat'
  TODO_ITEM_THREE = 'book a doctors appointment'

  def todo_items
    page.all("#todo-list li")
  end

  def create_standard_items
    enter_item(TODO_ITEM_ONE)
    enter_item(TODO_ITEM_TWO)
    enter_item(TODO_ITEM_THREE)
  end

  def enter_item(text)
    fill_in 'new-todo', with: text
    page.execute_script("document.getElementById('new_todo').submit()")
  end
end
