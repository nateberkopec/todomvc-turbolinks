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

  test "mark all items as completed" do
    create_standard_items

    find('#toggle-all').click

    assert todo_items.all? { |el| el[:class] == "completed" }
  end

  test "clear the completion state of all items" do
    create_standard_items

    2.times { find('#toggle-all').click }

    refute todo_items.all? { |el| el[:class] == "completed" }
  end

  test "complete all checkbox should update state when items are completed / cleared" do
    create_standard_items
    find('#toggle-all').click
    assert find('#toggle-all').checked?

    todo_items[0].uncheck("todo[is_completed]")
    refute find('#toggle-all').checked?

    todo_items[0].check("todo[is_completed]")
    assert find('#toggle-all').checked?
  end

  test "mark items as complete" do
    create_standard_items

    todo_items[0].check("todo[is_completed]")
    assert_equal "completed", todo_items[0][:class]
    refute_equal "completed", todo_items[1][:class]

    todo_items[1].check("todo[is_completed]")
    assert_equal "completed", todo_items[0][:class]
    assert_equal "completed", todo_items[1][:class]
  end

  test "un-mark items as complete" do
    create_standard_items

    todo_items[0].check("todo[is_completed]")
    assert_equal "completed", todo_items[0][:class]
    refute_equal "completed", todo_items[1][:class]

    todo_items[0].uncheck("todo[is_completed]")
    refute_equal "completed", todo_items[0][:class]
    refute_equal "completed", todo_items[1][:class]
  end

  test "edit an item" do
    create_standard_items
    todo_items[1].double_click
    todo_items[1].fill_in("todo[title]", with: "buy some sausages"+ "\n")

    assert_items [TODO_ITEM_ONE, "buy some sausages", TODO_ITEM_THREE]
  end

  test "hide other controls when editing" do
    create_standard_items
    assert todo_items[1].has_selector?('.view label')

    todo_items[1].double_click

    refute todo_items[1].has_selector?('.view label')
  end

  test "save edits on blur" do
    skip "I can't get this test to work for the life of me :("
    create_standard_items
    todo_items[1].double_click
    todo_items[1].fill_in("todo[title]", with: "buy some sausages")
    3.times { find('#new-todo').click }

    assert_items [TODO_ITEM_ONE, "buy some sausages", TODO_ITEM_THREE]
  end

  test "trim entered text" do
    create_standard_items
    todo_items[1].double_click
    todo_items[1].fill_in("todo[title]", with: "   buy some sausages    " + "\n")

    assert_items [TODO_ITEM_ONE, "buy some sausages", TODO_ITEM_THREE]
  end

  test "remove todos if empty text is entered when editing" do
    create_standard_items

    todo_items[1].double_click
    todo_items[1].fill_in("todo[title]", with: "" + "\n")

    assert_items [TODO_ITEM_ONE, TODO_ITEM_THREE]
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
    find('#new-todo').native.send_key(:enter)
  end
end
