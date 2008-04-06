module Vanilla
  class RenderResult
    # Slightly ambiguos / non-standard names to avoid clashes with hosting frameworks
    attr_accessor :result, :meta, :rendered_content
    
    def initialize(result = 200, meta = {"Content-Type" => 'text/html'}, rendered_content = '')
      @result = result
      @meta = meta
      @rendered_content = rendered_content
    end
    
    def failure(problem = nil)
      self.result = 500
      self.rendered_content = problem unless problem.nil?
    end
    
    def is_failure?
      result == 500
    end
    
    def missing(whats_missing = nil)
      self.result = 404
      self.rendered_content = whats_missing unless whats_missing.nil?
    end
    
    def is_missing?
      result == 404
    end
    
    def success(oh_happy_day = nil)
      self.result = 200
      self.rendered_content = oh_happy_day unless oh_happy_day.nil?
    end
    
    def is_success?
      result == 200
    end
  end
end