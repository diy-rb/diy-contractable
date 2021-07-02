# frozen_string_literal: true

require 'diy/contractable/base_contract/chainable'

module DIY
  module Contractable
    # Generic contract
    class BaseContract
      include Chainable
      include DIY::Carrierable

      # Prefix for validation methods
      PREFIX = /validate_/.freeze

      # @param payload [Object] validation payload
      # @return [SuccessCarrier, FailureCarrier]
      def call(payload)
        perform(payload)
      end

      private

      # @!attribute [rw] payload
      #   @return [Object]
      attr_accessor :payload

      # @return [Hash]
      def errors
        @errors ||= {}
      end

      # @param attribute [Symbol]
      # @param details [Symbol, Hash, Array<Symbol>, Array<Hash>]
      def error(attribute, details)
        errors[attribute.to_sym] ||= []

        method = details.is_a?(Array) ? 'concat' : 'push'
        errors[attribute.to_sym].public_send(method, details)
      end

      # This method returns a duplicate of the current errors hash as failure errors.
      # This is used for ability to process many payload object via single instance of the contract.
      # Due to dependency injection for some contracts, it is a bad smell to instantiate
      # every contract with dependencies for each instance
      #
      # @param payload [Object]
      # @return [SuccessCarrier, FailureCarrier]
      def perform(payload)
        self.payload = payload

        validate
        carrier = errors.none? ? success(payload) : failure(:validation_failed, errors.clone, payload)

        self.payload = nil
        errors.clear

        carrier
      end

      def validate
        if chain.present?
          chain.each { |method| errors.any? ? break : send(method) }
          return
        end

        private_methods.grep(PREFIX).each { |method| send(method) }
      end
    end
  end
end
