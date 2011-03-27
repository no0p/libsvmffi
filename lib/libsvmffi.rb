require 'ffi'

module Libsvmffi

  extend FFI::Library
  ffi_lib 'libsvm' # REVIEW

  attach_function 'svm_train', [:pointer, :pointer], :pointer
  attach_function 'svm_predict', [:pointer, :pointer], :double

end
