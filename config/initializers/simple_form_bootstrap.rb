# frozen_string_literal: true

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn btn-primary'
  config.boolean_label_class = nil

  config.wrappers :form, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'form-text text-muted' }
  end

  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label

    b.use :input, class: 'form-control-file'
    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'text-muted' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'form-check' do |ba|
      ba.use :input, class: 'form-check-input'
      ba.use :label, class: 'form-check-label'
    end

    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'text-muted' }
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div',
                                                  class: 'form-group' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form-check-label'

    b.wrapper tag: 'div', class: 'form-check' do |ba|
      ba.use :input, class: 'form-check-input'
      ba.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
      ba.use :hint,  wrap_with: { tag: 'small', class: 'text-muted' }
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'form-group' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'form-control mb-2 mr-sm-2'
    b.use :error, wrap_with: { tag: 'div', class: 'invalid-feedback' }
    b.use :hint,  wrap_with: { tag: 'small', class: 'text-muted' }
  end

  config.default_wrapper = :form
  config.wrapper_mappings = {
    check_boxes: :vertical_radio_and_checkboxes,
    radio_buttons: :vertical_radio_and_checkboxes,
    file: :vertical_file_input,
    boolean: :vertical_boolean
  }
end

inputs = %w[
  CollectionSelectInput
  DateTimeInput
  FileInput
  GroupedCollectionSelectInput
  NumericInput
  PasswordInput
  RangeInput
  StringInput
  TextInput
]

inputs.each do |input_type|
  superclass = "SimpleForm::Inputs::#{input_type}".constantize

  new_class = Class.new(superclass) do
    def input_html_classes
      if has_errors?
        super.push('is-invalid')
      else
        super
      end
    end
  end

  Object.const_set(input_type, new_class)
end
