module Libsvmffi
  #
  #
  #
  class Model
 
    attr_accessor :parameters, :problem, :svm_model

    def initialize(options = {})

      @parameters = Parameters.new      
      
      # TODO merge defaults options hash.
      @parameters[:svm_type] = C_SVC;
      @parameters[:kernel_type] = RBF;
      @parameters[:degree] = 3;
      @parameters[:gamma] = 0;  # 1/num_features
      @parameters[:coef0] = 0;
      @parameters[:nu] = 0.5;
      @parameters[:cache_size] = 100;
      @parameters[:C] = 1;
      @parameters[:eps] = 0.001;
      @parameters[:p] = 0.1;
      @parameters[:shrinking] = 1;
      @parameters[:probability] = 0;
      @parameters[:nr_weight] = 0;
      @parameters[:weight_label] = nil;
      @parameters[:weight] = nil;
    end


    def add(label, features)
      
    end

    def train
    
    end

    def save

    end
   
  end
end
