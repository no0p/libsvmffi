require 'ffi'
require 'libsvmffi/problem'
require 'libsvmffi/parameters'
require 'libsvmffi/node'
require 'libsvmffi/model'


module Libsvmffi

  extend FFI::Library
  ffi_lib 'svm' # REVIEW

  C_SVC, NU_SVC, ONE_CLASS, EPSILON_SVR, NU_SVR = 0, 1, 2, 3, 4 # SVM Type
  LINEAR, POLY, RBF, SIGMOID, PRECOMPUTED = 0, 1, 2, 3, 4       # Kernel Type

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
