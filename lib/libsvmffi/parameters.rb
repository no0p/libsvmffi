module Libsvmffi
  class Parameters < FFI::Struct
    layout :svm_type, :int,
         :kernel_type, :int,
         :degree, :int,           # for poly
         :gamma, :double,         # for poly/rbf/sigmoid
         :coef0, :double,         # for poly/sigmoid
         :cache_size, :double ,   # in MB
         :eps, :double,           # stopping criteria
         :C, :double,             # for C_SVC, EPSILON_SVR and NU_SVR
         :nr_weight, :int,        # for C_SVC
         :weight_label, :pointer, # int for C_SVC
         :weight, :pointer,       # double for C_SVC
         :nu, :double,            # for NU_SVC, ONE_CLASS, and NU_SVR
         :p, :double,             # for EPSILON_SVR
         :shrinking, :int,        # use the shrinking heuristics
         :probability, :int       # do probability estimates
  end
end
