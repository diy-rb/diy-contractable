# frozen_string_literal: true

module DIY
  module Contractable
    class BaseContract
      # Adds ability to control the order of the methods execution
      module Chainable
        def self.included(base)
          base.extend(ClassMethods)
        end

        # @return [Array<Symbol>, nil]
        def chain
          self.class.execution_chain
        end

        # Comprises from methods, which will be extended by the class as it's own class methods
        module ClassMethods
          # @!attribute [rw] execution_chain
          #   @return [Array<Symbol>]
          attr_accessor :execution_chain

          # @param methods [Array<Symbol>]
          def chain(*methods)
            self.execution_chain = methods
          end
        end
      end
    end
  end
end
