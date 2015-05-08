# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "click", "[data-behavior~=submit_on_check]", ->
  $(@).closest("form").submit()

$(document).on "blur", "[data-behavior~=submit_on_blur]", ->
  $(@).closest("form").submit()

$(document).on "dblclick", "[data-behavior~=toggle_form_on_dblclick]", ->
  $(@).find(".toggle-me").toggle().focus()
  $(@).toggleClass("editing")
