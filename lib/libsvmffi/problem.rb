module Libsvmffi
  class Problem < FFI::Struct
    layout :l, :int,
          :y, :pointer,
          :x, :pointer # svm_node
  end
end
