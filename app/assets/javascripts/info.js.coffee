$(document).keypress (e) ->
  $('#nav').find('.terminal').find('input').focus()

$('#nav').find('.terminal').submit () ->
  return false

showText = (target, message, index, interval) ->
  if (index < message.length) 
    $(target).append(message[index++])
    setTimeout () -> 
      showText(target, message, index, interval - 5)
    , interval
terminal_flag = false
nav_guide_height = $('#nav').find('.guide').outerHeight()
$('#nav').find('.terminal').find('input').focusin( () ->
  if $(this).val() == 'work'
    $('#nav').find('.guide').hide()
  $(this).attr('placeholder', 'enter a page to display')
  $('#nav').find('.guide').animate({opacity: 1}).show()
  if terminal_flag == false
    terminal_flag = true
    $('#nav').find('.guide').find('div').each (i, elem) ->
      if $(this).attr('class') == 'left' || $(this).attr('class') == 'right'
        curr_text = arr.shift()
        showText($(this), curr_text, 0, 75)
)
$('#nav').find('.terminal').find('input').focusout( () ->
  $(this).attr('placeholder', 'start typing or click here to navigate')
  $('#nav').find('.guide').css({opacity: 0.5})
)

arr = []
clear_nav_guide = () ->
  $('#nav').find('.guide').find('div').each () ->
    if $(this).attr('class') == 'left' || $(this).attr('class') == 'right'
      arr.push($(this).text().replace(/\s+/g, ' '))
      $(this).text('')

clear_nav_guide()

absolute_left = $(window).scrollLeft()
banner_logo_pos = $('#banner').find('.banner-logo').offset().left
banner_dev_des_pos = $('#banner').find('.banner-dev-des').offset().left - $('#banner').find('.banner-logo').width()
$('#banner').find('.banner-logo').css({position: 'absolute', left: -1000})
$('#banner').find('.banner-dev-des').css({position: 'absolute', right: -1000})
$('#banner').find('.banner-logo').animate({left: banner_logo_pos}, 1500, () -> $(this).css({position: 'relative', left: 0}))
$('#banner').find('.banner-dev-des').animate(
  {right: banner_dev_des_pos}, 1500, () -> 
    $(this).css({position: 'relative', right: 0})
    $('#nav').fadeIn('slow')
)

$(window).scroll () ->
  global_pos = $(this).scrollTop()
  $('#banner').css({opacity: 1-global_pos/300})
  $('#banner').find('.banner-logo').css({marginTop: -(global_pos/2), opacity: 1-global_pos/100})
  $('#banner').find('.banner-dev-des').css({marginTop: -(global_pos/2), opacity: 1-global_pos/100})
  if $('#nav').find('.terminal').find('input').val().length == 0
    $('#nav').find('.guide').slideUp()
  
  
  
  
  
  