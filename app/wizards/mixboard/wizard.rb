# frozen_string_literal: true

module Mixboard
  class Wizard
    attr_accessor :errors, :action

    MOVE_TO_PREVIOUS_STEP = :previous
    SUBMIT_STEP = :submit
    MOVE_TO_NEXT_STEP = :next

    def step_classes()
      return []
    end

    def finish()
        
    end

    def initialize(data = nil)
      create_current_step(data) unless data.nil?
    end

    def errors
      @current_step.validate unless @current_step.nil?
    end

    # Gets the next step for the wizard. If there is no current step, then this must be a request for the first step.
    # If there is a current_step, it could return a sub-step, itself, or return :continue to move to the next stage of
    # the wizard. Returns nil if the wizard is finished.
    def next_step
      if @current_step.nil?
        step_classes.first
      elsif @current_step.next_step == CONTINUE
        step_classes[step_classes.index(@current_step_class) + 1]
      else
        @current_step.next_step
      end
    end

    private

    def create_current_step(data)
      if data[:step].nil?
        raise ArgumentError.new(":step was nil")
      end
      @current_step_class = class_from_string(data[:step])
      if @current_step_class.nil?
        raise ArgumentError.new(":step was invalid (nil after class resolution)")
      end
      @current_step = @current_step_class.new(data)
    end

    def class_from_string(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    rescue
      nil
    end

  end
end
