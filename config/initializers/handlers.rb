# frozen_string_literal: true

ActionView::Template.register_template_handler :ch, CsvHandler::Handler
