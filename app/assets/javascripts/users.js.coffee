# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#user_payment_method').change ->
    $('.payment_instructions').hide()
    $('#pmt_'+$(this).val()).show()
