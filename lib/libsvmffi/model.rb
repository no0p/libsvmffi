module Libsvmffi
  #
  #
  #
  class Model
 
    attr_accessor :parameters, :problem, :svm_model
    attr_accessor :examples
    attr_accessor :labels, :features 
    attr_accessor :elements, :x_space
    
    attr_accessor :nodes, :x

    TMP_MODEL_FILE = "/tmp/libsvm_model.out"

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
      
      @nodes = []
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
      @problem[:l] = @examples.length
      @problem[:y] = FFI::MemoryPointer.new(:double, @problem[:l])
      @x = FFI::MemoryPointer.new(:pointer, @problem[:l])
      @problem[:x] = @x.address #FFI::MemoryPointer.new(:pointer, @problem[:l])
      @x_space = FFI::MemoryPointer.new(Node, @elements) 

      y = @examples.map {|e| e.keys.first}
      @problem[:y].put_array_of_double 0, y

      i = 0
      space_index = 0
      examples.each do |ex| #TODO clean up this hash structure
        ex.each do |e|
          @x[i].write_pointer @x_space[space_index]
          i += 1          
 
          features = e.last.merge({-1 => 0}) #terminator
          features.each do |k, v|
            n = Node.new @x_space[space_index]
            n[:index] = k
            n[:value] = v
            space_index += 1
            
            @nodes.push n
          end
        end
      end
      
      @parameters[:gamma] = 1 / @features.length.to_f
      
      @svm_model = Libsvmffi.svm_train @problem.pointer, @parameters.pointer
      
    end

    #
    #
    #
    def classify(features)   
      nodes = fton(features) 
      label_index = Libsvmffi.svm_predict @svm_model, nodes
      @labels[label_index.to_i]
    end
    

    def marshal_dump
      
        d = Marshal.dump @labels
        d += "::::"
        d += Marshal.dump @features
      if !@svm_model.nil?
        # TODO surely there is a better way to do this.
        save_raw
        raw_str = File.open(TMP_MODEL_FILE, "r").read
        d += "::::"  
        d += raw_str
      end
      
      return d
    end

    def marshal_load(str)
      @labels, @features, raw_model = str.split("::::")
      
      @labels = Marshal.load @labels
      @features = Marshal.load @features
      
      File.open(TMP_MODEL_FILE, "w") {|f| f.write raw_model}
      restore_raw
    end
  
    #
    # Save to file
    #
    def save_raw
      Libsvmffi.svm_save_model FFI::MemoryPointer.from_string(TMP_MODEL_FILE), @svm_model
    end

    #
    # Restore a model from a file. 
    #   NOTE: currently does not restore pre-train data
    #
    def restore_raw
      @svm_model = Libsvmffi.svm_load_model FFI::MemoryPointer.from_string(TMP_MODEL_FILE)
    end
    
    #
    # Add training examples from a libsvm training format file
    #
    def add_from_file(filename)
      f = File.open filename, 'r'
      f.lines.each do |l|
        tokens = l.split " "
        label = tokens.shift
        features = {}
        tokens.each do |t|
          index, value = t.split(":")
          features[index.to_i] = value.to_f
        end
        self.add label, features 
      end
    end
   
    #
    # Features to array of node struct (currently factored just for debugging, only used in predict)
    #
    def fton(features)
    
     indexed_features = {}
      features.each do |k, v|
        indexed_features[@features.index(k)] = v unless !@features.include? k
      end
      
      nodes = FFI::MemoryPointer.new(Node, indexed_features.length + 1)
      indexed_features = indexed_features.merge({-1 => 0}) #terminator
      i = 0
      indexed_features.each do |k, v|
        n = Node.new nodes[i]
        n[:index] = k
        n[:value] = v
        i += 1
      end
      
      return nodes
      
    end
   
  end
end
