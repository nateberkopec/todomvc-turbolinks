# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "click", "[data-behavior~=submit_on_check]", ->
  $(@).closest("form").submit()

$(document).on "page:before-unload", ->
  debugger
  window.prevPageYOffset = window.pageYOffset
  window.prevPageXOffset = window.pageXOffset
$(document).on "page:load", ->
  window.scrollTo window.prevPageXOffset, window.prevPageYOffset
