module Libsvmffi
  #
  #
  #
  class Model
 
    attr_accessor :parameters, :problem, :svm_model
    attr_accessor :examples
    attr_accessor :labels, :features 
    attr_accessor :elements

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
      
      @elements = 0
      @examples, @labels, @features = [], [], []
    end

    #
    # Adds an example which will be used upon trainining
    #
    def add(label, features)
      @labels.push label unless @labels.include? label
      indexed_features = {}
      features.each do |k, v|
        @features.push k unless @features.include? k
        indexed_features[@features.index(k)] = v
      end

      @examples.push({@labels.index(label) => indexed_features})

      @elements += features.length + 1 # also -1 terminator, see libsvm readme.
    end

    #
    # Build libsvm model
    # 
    def train

      @problem = Problem.new
      @problem.l = @examples.length
      @problem.y = @examples.keys
      @problem.x = FFI::MemoryPointer.new(:pointer, @problem.l)
      @x_space = FFI::MemoryPointer.new(:pointer, @elements)

      space_index = 0
      @examples.values.each_with_index do |e, i|
        @problem.x[i] = @x_space[space_index].pointer
      
        e.merge!({-1 => 0}) #terminator
        e.each do |k, v|
          n = Node.new
          n[:index] = k
          n[:value] = v
          @x_space[space_index] = n.pointer
          space_index += 1
        end
      end
      
      # @svm_model = svm_train @problem.pointer, @paramaters.pointer
      
    end

    #
    # Save to file
    #
    def save(filename = "thing")
       #svm_save_model filename, @svm_model.pointer
    end
    
   
  end
end
