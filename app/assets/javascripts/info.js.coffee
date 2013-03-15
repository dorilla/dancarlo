# Placholders plugin setup
Placeholders.init({'live': true, 'hideOnFocus': false})

# press any key anywhere forces focus on terminal
$(document).keypress (e) ->
  if terminal_focused == false
    $('#nav').find('.terminal').find('input').focus()
# clicking into the entire top "bar" forces focus on terminal
$('#nav').click () ->
  if terminal_focused == false
    $('#nav').find('.terminal').find('input').focus()

# TODO nav submit action
$('#nav').find('.terminal').submit () ->
  return false

# function to show text on a letter-by-letter bases
# sets the interval at which to initially show each letter
# decreases this number by 5 after each letter shown
showText = (target, message, index, interval) ->
  if (index < message.length) 
    $(target).append(message[index++])
    setTimeout () -> 
      showText(target, message, index, interval - 5)
    , interval

terminal_flag = false           # flag to check if terminal is loaded initially
terminal_focused = false        # flag to check if terminal is being focused on
nav_guide_height = $('#nav').find('.guide').outerHeight() # height of nav bar

# event: terminal focus
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
) # after event
$('#nav').find('.terminal').find('input').focusout( () ->
  terminal_focused = false
  $(this).attr('placeholder', 'start typing or click here to navigate')
  $('#nav').find('.guide').animate({opacity: 0.5})
)

# clear terminal guide text initially
arr = []
clear_nav_guide = () ->
  $('#nav').find('.guide').find('div').each () ->
    if $(this).attr('class') == 'left' || $(this).attr('class') == 'right'
      arr.push($(this).text().replace(/\s+/g, ' '))
      $(this).text('')
clear_nav_guide()

absolute_left = $(window).scrollLeft()      # browser window's absolute left pos
banner_logo_pos = $('#banner').find('.banner-logo').offset().left
banner_dev_des_pos = $('#banner').find('.banner-dev-des').offset().left - $('#banner').find('.banner-logo').width()
# banner animations
$('#banner').find('.banner-logo').css({position: 'absolute', left: -1000})
$('#banner').find('.banner-dev-des').css({position: 'absolute', right: -1000})
$('#banner').find('.banner-logo').animate({left: banner_logo_pos}, 1500, () -> $(this).css({position: 'relative', left: 0}))
$('#banner').find('.banner-dev-des').animate(
  {right: banner_dev_des_pos}, 1500, () -> 
    $(this).css({position: 'relative', right: 0})
    $('#nav').fadeIn('slow')
    $('#banner').find('.down-arrow').fadeIn('slow')
)

# on scroll animations
$(window).scroll () ->
  global_pos = $(this).scrollTop()
  $('#banner').css({opacity: 1-global_pos/250})
  $('#banner').find('.down-arrow').css({opacity: 1-global_pos/400})
  $('#banner').find('.banner-logo').add('.banner-dev-des').css({marginTop: -(global_pos/2.5), opacity: 1-global_pos/100})
  if $('#nav').find('.terminal').find('input').val().length == 0
    $('#nav').find('.guide').slideUp()
  works_wrap = $('#works')
  works_wrap_bottom = works_wrap.offset().top + works_wrap.outerHeight()
  if global_pos > 300 && global_pos < works_wrap_bottom
    works_wrap.show().css({opacity: (global_pos-300)/200})
  else if global_pos >= works_wrap_bottom
    works_wrap.show().css({opacity: 1-(global_pos-works_wrap_bottom)/200})
  else
    works_wrap.hide()

# single work nav actions
works_actions = (absolute_width) ->
  $('.single-work').find('.nav').find('.right').each () ->
    $(this).unbind()
  $('.single-work').find('.nav').find('.left').each () ->
    $(this).unbind()
  $('.single-work').each () ->
    curr_content_active = $(this).find('.content-wrap').find('.content.active')
    curr_index = curr_content_active.index()
    if curr_content_active.hasClass('light-bg') then $(this).find('.nav').find('.arrow').removeClass('white').addClass('oj') else $(this).find('.nav').find('.arrow').removeClass('oj').addClass('white') 
    $(this).find('.content-wrap').each () ->
      $(this).css({width: (absolute_width * $(this).find('.content').length), marginLeft: -(absolute_width * curr_index)})
    $('.single-work').find('.content-wrap').find('.content').each (i, elem) ->
      $(this).css({width: absolute_width})
    
  $('.single-work').find('.nav').find('.right').each () ->
    $(this).click (e) ->
      anim($(this), e)
    anim = (elem, event) ->
      elem.unbind(event);
      single_work = elem.parent().parent()
      content_wrap = single_work.find('.content-wrap')
      single_work_last_content_margin = parseInt(content_wrap.css('width')) - absolute_width
      curr_margin = parseInt(content_wrap.css('marginLeft'))
      if (curr_margin >= -single_work_last_content_margin)
        if (curr_margin >= 0)
          elem.parent().find('.left').addClass('active')
        if (curr_margin <= -(single_work_last_content_margin - absolute_width))
          elem.removeClass('active')
      curr_index = Math.abs(curr_margin) / absolute_width
      content_wrap.find('.content.active').removeClass('active').next().addClass('active')
      content_wrap.animate({marginLeft: curr_margin - absolute_width}, () -> 
        if single_work.find('.content.active').hasClass('light-bg') then single_work.find('.nav').find('.arrow').removeClass('white').addClass('oj') else single_work.find('.nav').find('.arrow').removeClass('oj').addClass('white') 
        elem.click (e) -> anim(elem, e)
      )
      
  $('.single-work').find('.nav').find('.left').each () ->
    $(this).click (e) ->
      anim($(this), e)
    anim = (elem, event) ->
      elem.unbind(event);
      single_work = elem.parent().parent()
      content_wrap = single_work.find('.content-wrap')
      single_work_last_content_margin = parseInt(content_wrap.css('width')) - absolute_width
      curr_margin = parseInt(content_wrap.css('marginLeft'))
      if (curr_margin < 0)
        if (curr_margin <= -single_work_last_content_margin)
          elem.parent().find('.right').addClass('active')
        if (curr_margin >= -absolute_width)
          elem.removeClass('active')
      curr_index = Math.abs(curr_margin) / absolute_width
      content_wrap.find('.content.active').removeClass('active').prev().addClass('active')
      content_wrap.animate({marginLeft: curr_margin + absolute_width}, () -> 
        if single_work.find('.content.active').hasClass('light-bg') then single_work.find('.nav').find('.arrow').removeClass('white').addClass('oj') else single_work.find('.nav').find('.arrow').removeClass('oj').addClass('white') 
        elem.click (e) -> anim(elem, e)
      )
      
works_actions($(window).outerWidth())
$(window).resize () ->
  $('.single-work').find('.content-wrap').stop()
  works_actions($(window).outerWidth())
  
  
  
  
  