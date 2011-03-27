require 'ffi'

module Libsvmffi

  extend FFI::Library
  ffi_lib 'libsvm' # REVIEW

  attach_function 'svm_train', [:pointer, :pointer], :pointer

  attach_function 'svm_cross_validation', [:pointer, :pointer, :int, :pointer], :void

  attach_function 'svm_save_model', [:pointer, :pointer], :int
  attach_function 'svm_load_model', [:pointer], :pointer

  attach_function 'svm_get_svm_type', [:pointer], :int
  attach_function 'svm_get_nr_class', [:pointer], :int
  attach_function 'svm_get_labels', [:pointer, :pointer], :void
  attach_function 'svm_get_svr_probability', [:pointer], :double

  attach_function 'svm_predict', [:pointer, :pointer], :double
  attach_function 'svm_predict_values', [:pointer, :pointer, :pointer], :void
  attach_function 'svm_predict_probability', [:pointer, :pointer, :pointer], :double

  attach_function 'svm_destroy_model', [:pointer], :void
  attach_function 'svm_destroy_param', [:pointer], :void

  attach_function 'svm_check_parameter', [:pointer, :pointer], :pointer
  attach_function 'svm_check_probability_model', [:pointer], :int

end
