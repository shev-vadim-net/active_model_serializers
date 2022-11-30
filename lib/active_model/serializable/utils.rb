module ActiveModel
  module Serializable
    module Utils
      extend self

      # It seems like the Ruby 2.7 changes the behaviour of the `Object.const_get method`.
      # In the previous versions the `Object.const_get('Projects::EBookSerializer')` returns `EBookSerializer`,
      # but now it raises `NameError`.
      # We totally understand the Ruby's 2.7 behaviour is now fixed and the previous versions resolved
      # a constant name in an incorrect way, but we don't want to invest additional time to fix all these
      # issues across the project. Especially when we have plans to replace this serializer with a newer one.
      #
      # So the workaround is to get a constant via `Object.const_get('Projects').const_get('EBookSerializer')`
      # which seems to work the same as in the previous Ruby version - means incorrectly.
      # See some info here https://gitlab.com/gitlab-org/gitlab/-/issues/27678
      def _const_get(const)
        begin
          const.split('::').inject(Object) { |obj, const_name| obj.send(:const_get, const_name) }
        rescue NameError
          const.safe_constantize
        end
      end
    end
  end
end