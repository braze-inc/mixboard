# frozen_string_literal: true

module Mixboard
  class NewDynamicChannelWizard < Mixboard::Wizard

    def step_classes()
      return [AddSourceWizardStep]
    end

  end
end
