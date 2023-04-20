# frozen_string_literal: true

class VerticalNavbarComponent < ViewComponent::Base
  renders_many :tabs, "TabComponent"

  class TabComponent < ViewComponent::Base
    delegate :link_to, :current_page?, to: :helpers

    def initialize(name:, path:, **options)
      @name = name
      @path = path
      @options = options
    end

    def call
      classes = if @options.key?(:class)
                  @options[:class]
                elsif current_tab?
                  %w[nav-link active]
                else
                  ["nav-link"]
                end
      link_path = current_tab? ? "#" : @path
      link_to @name, link_path,
              class: classes, role: "tab",
              aria: { selected: current_tab? }
    end

    def current_tab?
      @options.key?(:current_tab) ? @options[:current_tab] : current_page?(@path)
    end
  end
end
