require File.expand_path(File.dirname(__FILE__) + '/helper')

class TestViewExtensions < ActiveSupport::TestCase

  context "property set view extensions" do
    setup do
      @association = :settings
      @property    = :active
      @builder     = ActionView::Helpers::FormBuilder.new("object_name", "object", "template", "options", "proc")
      @proxy       = @builder.property_set(@association)
    end

    should "provide a form builder proxy" do
      assert @proxy.is_a?(ActionView::Helpers::FormBuilder::PropertySetFormBuilderProxy)
      assert_equal @association, @proxy.property_set
    end

    context "check_box" do
      should "call with checked true for a truth value" do
        settings = stub(@property => "1", "#{@property}?".to_sym => true)
        object   = stub()
        object.expects(@association).returns(settings)
        options  = {
          :checked => true, :name => "object_name[#{@association}][#{@property}]",
          :id => "object_name_#{@association}_#{@property}", :object => object
        }
        template = stub()
        template.expects(:instance_variable_get).with("@object_name").returns(object)
        # def check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
        template.expects(:check_box).with("object_name", @property, options, "1", "0")

        @proxy.stubs(:template).returns(template)
        @proxy.check_box(@property)
      end

      should "call with checked false for a truth value" do
        settings = stub(@property => "0", "#{@property}?".to_sym => false)
        object   = stub()
        object.expects(@association).returns(settings)
        options  = {
          :checked => false, :name => "object_name[#{@association}][#{@property}]",
          :id => "object_name_#{@association}_#{@property}", :object => object
        }
        template = stub()
        template.expects(:instance_variable_get).with("@object_name").returns(object)
        # def check_box(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
        template.expects(:check_box).with("object_name", @property, options, "1", "0")

        @proxy.stubs(:template).returns(template)
        @proxy.check_box(@property)
      end
    end

    context "radio_button" do
      should "call with checked true for a truth value" do
        settings = stub(@property => "hello")
        object   = stub()
        object.expects(@association).returns(settings)
        options  = {
          :checked => true, :name => "object_name[#{@association}][#{@property}]",
          :id => "object_name_#{@association}_#{@property}", :object => object
        }
        template = stub()
        template.expects(:instance_variable_get).with("@object_name").returns(object)
        # def radio_button(object_name, method, tag_value, options = {})
        template.expects(:radio_button).with("object_name", @property, "hello", options)

        @proxy.stubs(:template).returns(template)
        @proxy.radio_button(@property, "hello")
      end
    end
  end
end
