Locomotive.Views.Shared ||= {}

class Locomotive.Views.Shared.FormView extends Backbone.View

  el: '.main'

  namespace: null

  events:
    'submit form':            'save'
    'ajax:aborted:required':  'show_empty_form_message'

  render: ->
    @inputs = []

    @display_active_nav()

    @enable_hover()

    @enable_file_inputs()
    @enable_array_inputs()
    @enable_toggle_inputs()
    @enable_date_inputs()
    @enable_datetime_inputs()
    @enable_text_inputs()
    @enable_rte_inputs()
    @enable_markdown_inputs()
    @enable_tags_inputs()
    @enable_document_picker_inputs()
    @enable_select_inputs()
    @enable_color_inputs()

    return @

  display_active_nav: ->
    url = document.location.toString()
    if url.match('#')
      name = url.split('#')[1]
      @$(".nav-tabs a[href='##{name}']").tab('show')

  record_active_tab: ->
    if $('form .nav-tabs li.active a').size() > 0
      tab_name = $('form .nav-tabs li.active a').attr('href').replace('#', '')
      @$('#active_tab').val(tab_name)

  change_state: ->
    @$('form button[type=submit]').button('loading')

  reset_state: ->
    @$('form button[type=submit]').button('reset')

  save: (event) ->
    @change_state()
    @record_active_tab()

  show_empty_form_message: (event) ->
    message = @$('form').data('blank-required-fields-message')

    Locomotive.notify message, 'error' if message?

    @reset_state()

  enable_hover: ->
    $('.form-group.input').hover ->
      $(this).addClass('hovered')
    , ->
      $(this).removeClass('hovered')

  enable_file_inputs: ->
    self = @
    @$('.input.file').each ->
      view = new Locomotive.Views.Inputs.FileView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_array_inputs: ->
    self = @
    @$('.input.array').each ->
      view = new Locomotive.Views.Inputs.ArrayView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_toggle_inputs: ->
    @$('.input.toggle input[type=checkbox]').each ->
      $toggle = $(@)
      $toggle.data('label-text', (if $toggle.is(':checked') then $toggle.data('off-text') else $toggle.data('on-text')))
      $toggle.bootstrapSwitch
        onSwitchChange: (event, state) ->
          $toggle.data('bootstrap-switch').labelText((if state then $toggle.data('off-text') else $toggle.data('on-text')))

  enable_date_inputs: ->
    @$('.input.date input[type=text]').each ->
      $(@).datetimepicker
        language: window.content_locale
        pickTime: false
        widgetParent: '.main'
        format: $(@).data('format')

  enable_datetime_inputs: ->
    @$('.input.date-time input[type=text]').each ->
      $(@).datetimepicker
        language: window.content_locale
        pickTime: true
        widgetParent: '.main'
        use24hours: true
        useseconds: false
        format: $(@).data('format')

  enable_text_inputs: ->
    self = @
    @$('.input.text').each ->
      view = new Locomotive.Views.Inputs.TextView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_rte_inputs: ->
    self = @
    @$('.input.rte').each ->
      view = new Locomotive.Views.Inputs.RteView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_markdown_inputs: ->
    self = @
    @$('.input.markdown').each ->
      view = new Locomotive.Views.Inputs.MarkdownView(el: $(@))
      view.render()
      self.inputs.push(view)

  enable_color_inputs: ->
    @$('.input.color .input-group').colorpicker(container: false, align: 'right')

  enable_tags_inputs: ->
    @$('.input.tags input[type=text]').tagsinput()

  enable_select_inputs: ->
    @$('.input.select select:not(.disable-select2)').select2()

  enable_document_picker_inputs: ->
    self = @
    @$('.input.document_picker').each ->
      view = new Locomotive.Views.Inputs.DocumentPickerView(el: $(@))
      view.render()
      self.inputs.push(view)

  remove: ->
    _.each @inputs, (view) -> view.remove()
    @$('.input.tags input[type=text]').tagsinput('destroy')
    @$('.input.select select').select2('destroy')
    @$('.input.color .input-group').colorpicker('destroy')

  _stop_event: (event) ->
    event.stopPropagation() & event.preventDefault()
