Placeholders.init({'live': true, 'hideOnFocus': false})

$(document).keypress (e) ->
  if terminal_focused == false
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
terminal_focused = false
nav_guide_height = $('#nav').find('.guide').outerHeight()
$('#nav').find('.terminal').find('input').focusin( () ->
  terminal_focused = true
  $(this).attr('placeholder', 'enter a page to display')
  if $(this).val() == 'work'
    $('#nav').find('.guide').hide()
  $('#nav').find('.guide').animate({opacity: 1}).show()
  if terminal_flag == false
    terminal_flag = true
    $('#nav').find('.guide').find('div').each (i, elem) ->
      if $(this).attr('class') == 'left' || $(this).attr('class') == 'right'
        curr_text = arr.shift()
        showText($(this), curr_text, 0, 75)
)
$('#nav').find('.terminal').find('input').focusout( () ->
  terminal_focused = false
  $(this).attr('placeholder', 'start typing or click here to navigate')
  $('#nav').find('.guide').animate({opacity: 0.5})
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
    $('#banner').find('.down-arrow').fadeIn('slow')
)

$(window).scroll () ->
  global_pos = $(this).scrollTop()
  $('#banner').css({opacity: 1-global_pos/250})
  $('#banner').find('.down-arrow').css({opacity: 1-global_pos/400})
  $('#banner').find('.banner-logo').add('.banner-dev-des').css({marginTop: -(global_pos/2.5), opacity: 1-global_pos/100})
  if $('#nav').find('.terminal').find('input').val().length == 0
    $('#nav').find('.guide').slideUp()
  work_wrap = $('#work').add('#betterific')
  work_wrap_bottom = $('#work').add('#betterific').offset().top + $('#work').add('#betterific').outerHeight() + 100
  if global_pos > 201 && global_pos < work_wrap_bottom 
    work_wrap.show().css({opacity: (global_pos-201)/200})
  else if global_pos >= work_wrap_bottom 
    work_wrap.show().css({opacity: 1-(global_pos-work_wrap_bottom)/200})
  else
    work_wrap.hide()
  
  
  
  
  
  