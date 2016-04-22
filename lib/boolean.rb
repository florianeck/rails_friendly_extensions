module Boolean
  [TrueClass, FalseClass].each do |bclass|
    bclass.class_eval do

      # return string if true/false
      def to_real(t = I18n.t('friendly_extensions.is_true'), f = I18n.t('friendly_extensions.is_false'))
        case self
        when TrueClass
          return t
        else
          return f
        end
      end

      # return integer if true/false
      def to_i
        case self
        when TrueClass
          return 1
        else
          return 0
        end
      end

    end
  end
end
