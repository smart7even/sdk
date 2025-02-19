// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../dart/resolution/node_text_expectations.dart';
import '../element_text.dart';
import '../elements_base.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(ClassElementTest_keepLinking);
    defineReflectiveTests(ClassElementTest_fromBytes);
    defineReflectiveTests(ClassElementTest_augmentation_keepLinking);
    defineReflectiveTests(ClassElementTest_augmentation_fromBytes);
    defineReflectiveTests(UpdateNodeTextExpectations);
  });
}

abstract class ClassElementTest extends ElementsBaseTest {
  test_class_abstract() async {
    var library = await buildLibrary('abstract class C {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class C @15
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_base() async {
    var library = await buildLibrary('base class C {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        base class C @11
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_const() async {
    var library = await buildLibrary('class C { const C(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const @16
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_const_external() async {
    var library = await buildLibrary('class C { external const C(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            external const @25
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_documented() async {
    var library = await buildLibrary('''
class C {
  /**
   * Docs
   */
  C();
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            @34
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              documentationComment: /**\n   * Docs\n   */
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_explicit_named() async {
    var library = await buildLibrary('class C { C.foo(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            foo @12
              reference: <testLibraryFragment>::@class::C::@constructor::foo
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 11
              nameEnd: 15
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_explicit_type_params() async {
    var library = await buildLibrary('class C<T, U> { C(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
            covariant U @11
              defaultType: dynamic
          constructors
            @16
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_explicit_unnamed() async {
    var library = await buildLibrary('class C { C(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            @10
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_external() async {
    var library = await buildLibrary('class C { external C(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            external @19
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_factory() async {
    var library = await buildLibrary('class C { factory C() => throw 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @18
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_dynamic_dynamic() async {
    var library =
        await buildLibrary('class C { dynamic x; C(dynamic this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @21
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @36
                  type: dynamic
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_dynamic_typed() async {
    var library = await buildLibrary('class C { dynamic x; C(int this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @21
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @32
                  type: int
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_dynamic_untyped() async {
    var library = await buildLibrary('class C { dynamic x; C(this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @21
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @28
                  type: dynamic
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_functionTyped_noReturnType() async {
    var library = await buildLibrary(r'''
class C {
  var x;
  C(this.x(double b));
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @16
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @21
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @28
                  type: dynamic Function(double)
                  parameters
                    requiredPositional b @37
                      type: double
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_functionTyped_withReturnType() async {
    var library = await buildLibrary(r'''
class C {
  var x;
  C(int this.x(double b));
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @16
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @21
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @32
                  type: int Function(double)
                  parameters
                    requiredPositional b @41
                      type: double
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_functionTyped_withReturnType_generic() async {
    var library = await buildLibrary(r'''
class C {
  Function() f;
  C(List<U> this.f<T, U>(T t));
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            f @23
              reference: <testLibraryFragment>::@class::C::@field::f
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic Function()
          constructors
            @28
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.f @43
                  type: List<U> Function<T, U>(T)
                  typeParameters
                    covariant T @45
                    covariant U @48
                  parameters
                    requiredPositional t @53
                      type: T
                  field: <testLibraryFragment>::@class::C::@field::f
          accessors
            synthetic get f @-1
              reference: <testLibraryFragment>::@class::C::@getter::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic Function()
            synthetic set f= @-1
              reference: <testLibraryFragment>::@class::C::@setter::f
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _f @-1
                  type: dynamic Function()
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_multiple_matching_fields() async {
    // This is a compile-time error but it should still analyze consistently.
    var library = await buildLibrary('class C { C(this.x); int x; String x; }');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @25
              reference: <testLibraryFragment>::@class::C::@field::x::@def::0
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
            x @35
              reference: <testLibraryFragment>::@class::C::@field::x::@def::1
              enclosingElement: <testLibraryFragment>::@class::C
              type: String
          constructors
            @10
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @17
                  type: int
                  field: <testLibraryFragment>::@class::C::@field::x::@def::0
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x::@def::0
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x::@def::0
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x::@def::1
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: String
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x::@def::1
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: String
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_no_matching_field() async {
    // This is a compile-time error but it should still analyze consistently.
    var library = await buildLibrary('class C { C(this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            @10
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @17
                  type: dynamic
                  field: <null>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_typed_dynamic() async {
    var library = await buildLibrary('class C { num x; C(dynamic this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: num
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @32
                  type: dynamic
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: num
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: num
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_typed_typed() async {
    var library = await buildLibrary('class C { num x; C(int this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: num
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @28
                  type: int
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: num
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: num
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_typed_untyped() async {
    var library = await buildLibrary('class C { num x; C(this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: num
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @24
                  type: num
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: num
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: num
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_untyped_dynamic() async {
    var library = await buildLibrary('class C { var x; C(dynamic this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @32
                  type: dynamic
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_untyped_typed() async {
    var library = await buildLibrary('class C { var x; C(int this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @28
                  type: int
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_field_formal_untyped_untyped() async {
    var library = await buildLibrary('class C { var x; C(this.x); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @24
                  type: dynamic
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_fieldFormal_named_noDefault() async {
    var library = await buildLibrary('class C { int x; C({this.x}); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                optionalNamed default final this.x @25
                  reference: <testLibraryFragment>::@class::C::@constructor::new::@parameter::x
                  type: int
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_fieldFormal_named_withDefault() async {
    var library = await buildLibrary('class C { int x; C({this.x: 42}); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                optionalNamed default final this.x @25
                  reference: <testLibraryFragment>::@class::C::@constructor::new::@parameter::x
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 42 @28
                      staticType: int
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_fieldFormal_optional_noDefault() async {
    var library = await buildLibrary('class C { int x; C([this.x]); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                optionalPositional default final this.x @25
                  type: int
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_fieldFormal_optional_withDefault() async {
    var library = await buildLibrary('class C { int x; C([this.x = 42]); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            @17
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                optionalPositional default final this.x @25
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 42 @29
                      staticType: int
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_implicit_type_params() async {
    var library = await buildLibrary('class C<T, U> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
            covariant U @11
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_assertInvocation() async {
    var library = await buildLibrary('''
class C {
  const C(int x) : assert(x >= 42);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional x @24
                  type: int
              constantInitializers
                AssertInitializer
                  assertKeyword: assert @29
                  leftParenthesis: ( @35
                  condition: BinaryExpression
                    leftOperand: SimpleIdentifier
                      token: x @36
                      staticElement: <testLibraryFragment>::@class::C::@constructor::new::@parameter::x
                      staticType: int
                    operator: >= @38
                    rightOperand: IntegerLiteral
                      literal: 42 @41
                      staticType: int
                    staticElement: dart:core::<fragment>::@class::num::@method::>=
                    staticInvokeType: bool Function(num)
                    staticType: bool
                  rightParenthesis: ) @43
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_assertInvocation_message() async {
    var library = await buildLibrary('''
class C {
  const C(int x) : assert(x >= 42, 'foo');
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional x @24
                  type: int
              constantInitializers
                AssertInitializer
                  assertKeyword: assert @29
                  leftParenthesis: ( @35
                  condition: BinaryExpression
                    leftOperand: SimpleIdentifier
                      token: x @36
                      staticElement: <testLibraryFragment>::@class::C::@constructor::new::@parameter::x
                      staticType: int
                    operator: >= @38
                    rightOperand: IntegerLiteral
                      literal: 42 @41
                      staticType: int
                    staticElement: dart:core::<fragment>::@class::num::@method::>=
                    staticInvokeType: bool Function(num)
                    staticType: bool
                  comma: , @43
                  message: SimpleStringLiteral
                    literal: 'foo' @45
                  rightParenthesis: ) @50
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_field() async {
    var library = await buildLibrary('''
class C {
  final x;
  const C() : x = 42;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            const @29
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: x @35
                    staticElement: <testLibraryFragment>::@class::C::@field::x
                    staticType: null
                  equals: = @37
                  expression: IntegerLiteral
                    literal: 42 @39
                    staticType: int
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_field_notConst() async {
    var library = await buildLibrary('''
class C {
  final x;
  const C() : x = foo();
}
int foo() => 42;
''');
    // It is OK to keep non-constant initializers.
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            const @29
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: x @35
                    staticElement: <testLibraryFragment>::@class::C::@field::x
                    staticType: null
                  equals: = @37
                  expression: MethodInvocation
                    methodName: SimpleIdentifier
                      token: foo @39
                      staticElement: <testLibraryFragment>::@function::foo
                      staticType: int Function()
                    argumentList: ArgumentList
                      leftParenthesis: ( @42
                      rightParenthesis: ) @43
                    staticInvokeType: int Function()
                    staticType: int
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
      functions
        foo @52
          reference: <testLibraryFragment>::@function::foo
          enclosingElement: <testLibraryFragment>
          returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_field_optionalPositionalParameter() async {
    var library = await buildLibrary('''
class A {
  final int _f;
  const A([int f = 0]) : _f = f;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _f @22
              reference: <testLibraryFragment>::@class::A::@field::_f
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            const @34
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                optionalPositional default f @41
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 0 @45
                      staticType: int
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: _f @51
                    staticElement: <testLibraryFragment>::@class::A::@field::_f
                    staticType: null
                  equals: = @54
                  expression: SimpleIdentifier
                    token: f @56
                    staticElement: <testLibraryFragment>::@class::A::@constructor::new::@parameter::f
                    staticType: int
          accessors
            synthetic get _f @-1
              reference: <testLibraryFragment>::@class::A::@getter::_f
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_field_recordLiteral() async {
    var library = await buildLibrary('''
class C {
  final Object x;
  const C(int a) : x = (0, a);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @25
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: Object
          constructors
            const @36
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional a @42
                  type: int
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: x @47
                    staticElement: <testLibraryFragment>::@class::C::@field::x
                    staticType: null
                  equals: = @49
                  expression: RecordLiteral
                    leftParenthesis: ( @51
                    fields
                      IntegerLiteral
                        literal: 0 @52
                        staticType: int
                      SimpleIdentifier
                        token: a @55
                        staticElement: <testLibraryFragment>::@class::C::@constructor::new::@parameter::a
                        staticType: int
                    rightParenthesis: ) @56
                    staticType: (int, int)
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_field_withParameter() async {
    var library = await buildLibrary('''
class C {
  final x;
  const C(int p) : x = 1 + p;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            const @29
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional p @35
                  type: int
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: x @40
                    staticElement: <testLibraryFragment>::@class::C::@field::x
                    staticType: null
                  equals: = @42
                  expression: BinaryExpression
                    leftOperand: IntegerLiteral
                      literal: 1 @44
                      staticType: int
                    operator: + @46
                    rightOperand: SimpleIdentifier
                      token: p @48
                      staticElement: <testLibraryFragment>::@class::C::@constructor::new::@parameter::p
                      staticType: int
                    staticElement: dart:core::<fragment>::@class::num::@method::+
                    staticInvokeType: num Function(num)
                    staticType: int
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_genericFunctionType() async {
    var library = await buildLibrary('''
class A<T> {
  const A();
}
class B {
  const B(dynamic x);
  const B.f()
   : this(A<Function()>());
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            const @21
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @34
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          constructors
            const @46
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional x @56
                  type: dynamic
            const f @70
              reference: <testLibraryFragment>::@class::B::@constructor::f
              enclosingElement: <testLibraryFragment>::@class::B
              periodOffset: 69
              nameEnd: 71
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @79
                  argumentList: ArgumentList
                    leftParenthesis: ( @83
                    arguments
                      InstanceCreationExpression
                        constructorName: ConstructorName
                          type: NamedType
                            name: A @84
                            typeArguments: TypeArgumentList
                              leftBracket: < @85
                              arguments
                                GenericFunctionType
                                  functionKeyword: Function @86
                                  parameters: FormalParameterList
                                    leftParenthesis: ( @94
                                    rightParenthesis: ) @95
                                  declaredElement: GenericFunctionTypeElement
                                    parameters
                                    returnType: dynamic
                                    type: dynamic Function()
                                  type: dynamic Function()
                              rightBracket: > @96
                            element: <testLibraryFragment>::@class::A
                            type: A<dynamic Function()>
                          staticElement: ConstructorMember
                            base: <testLibraryFragment>::@class::A::@constructor::new
                            substitution: {T: dynamic Function()}
                        argumentList: ArgumentList
                          leftParenthesis: ( @97
                          rightParenthesis: ) @98
                        staticType: A<dynamic Function()>
                    rightParenthesis: ) @99
                  staticElement: <testLibraryFragment>::@class::B::@constructor::new
              redirectedConstructor: <testLibraryFragment>::@class::B::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_superInvocation_argumentContextType() async {
    var library = await buildLibrary('''
class A {
  const A(List<String> values);
}
class B extends A {
  const B() : super(const []);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional values @33
                  type: List<String>
        class B @50
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            const @72
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @78
                  argumentList: ArgumentList
                    leftParenthesis: ( @83
                    arguments
                      ListLiteral
                        constKeyword: const @84
                        leftBracket: [ @90
                        rightBracket: ] @91
                        staticType: List<String>
                    rightParenthesis: ) @92
                  staticElement: <testLibraryFragment>::@class::A::@constructor::new
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_superInvocation_named() async {
    var library = await buildLibrary('''
class A {
  const A.aaa(int p);
}
class C extends A {
  const C() : super.aaa(42);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            const aaa @20
              reference: <testLibraryFragment>::@class::A::@constructor::aaa
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 19
              nameEnd: 23
              parameters
                requiredPositional p @28
                  type: int
        class C @40
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            const @62
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @68
                  period: . @73
                  constructorName: SimpleIdentifier
                    token: aaa @74
                    staticElement: <testLibraryFragment>::@class::A::@constructor::aaa
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @77
                    arguments
                      IntegerLiteral
                        literal: 42 @78
                        staticType: int
                    rightParenthesis: ) @80
                  staticElement: <testLibraryFragment>::@class::A::@constructor::aaa
              superConstructor: <testLibraryFragment>::@class::A::@constructor::aaa
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_superInvocation_named_underscore() async {
    var library = await buildLibrary('''
class A {
  const A._();
}
class B extends A {
  const B() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            const _ @20
              reference: <testLibraryFragment>::@class::A::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 19
              nameEnd: 21
        class B @33
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            const @55
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @61
                  period: . @66
                  constructorName: SimpleIdentifier
                    token: _ @67
                    staticElement: <testLibraryFragment>::@class::A::@constructor::_
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @68
                    rightParenthesis: ) @69
                  staticElement: <testLibraryFragment>::@class::A::@constructor::_
              superConstructor: <testLibraryFragment>::@class::A::@constructor::_
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_superInvocation_namedExpression() async {
    var library = await buildLibrary('''
class A {
  const A.aaa(a, {int b});
}
class C extends A {
  const C() : super.aaa(1, b: 2);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            const aaa @20
              reference: <testLibraryFragment>::@class::A::@constructor::aaa
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 19
              nameEnd: 23
              parameters
                requiredPositional a @24
                  type: dynamic
                optionalNamed default b @32
                  reference: <testLibraryFragment>::@class::A::@constructor::aaa::@parameter::b
                  type: int
        class C @45
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            const @67
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @73
                  period: . @78
                  constructorName: SimpleIdentifier
                    token: aaa @79
                    staticElement: <testLibraryFragment>::@class::A::@constructor::aaa
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @82
                    arguments
                      IntegerLiteral
                        literal: 1 @83
                        staticType: int
                      NamedExpression
                        name: Label
                          label: SimpleIdentifier
                            token: b @86
                            staticElement: <testLibraryFragment>::@class::A::@constructor::aaa::@parameter::b
                            staticType: null
                          colon: : @87
                        expression: IntegerLiteral
                          literal: 2 @89
                          staticType: int
                    rightParenthesis: ) @90
                  staticElement: <testLibraryFragment>::@class::A::@constructor::aaa
              superConstructor: <testLibraryFragment>::@class::A::@constructor::aaa
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_superInvocation_unnamed() async {
    var library = await buildLibrary('''
class A {
  const A(int p);
}
class C extends A {
  const C.ccc() : super(42);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional p @24
                  type: int
        class C @36
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            const ccc @60
              reference: <testLibraryFragment>::@class::C::@constructor::ccc
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 59
              nameEnd: 63
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @68
                  argumentList: ArgumentList
                    leftParenthesis: ( @73
                    arguments
                      IntegerLiteral
                        literal: 42 @74
                        staticType: int
                    rightParenthesis: ) @76
                  staticElement: <testLibraryFragment>::@class::A::@constructor::new
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_thisInvocation_argumentContextType() async {
    var library = await buildLibrary('''
class A {
  const A(List<String> values);
  const A.empty() : this(const []);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional values @33
                  type: List<String>
            const empty @52
              reference: <testLibraryFragment>::@class::A::@constructor::empty
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 51
              nameEnd: 57
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @62
                  argumentList: ArgumentList
                    leftParenthesis: ( @66
                    arguments
                      ListLiteral
                        constKeyword: const @67
                        leftBracket: [ @73
                        rightBracket: ] @74
                        staticType: List<String>
                    rightParenthesis: ) @75
                  staticElement: <testLibraryFragment>::@class::A::@constructor::new
              redirectedConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_thisInvocation_named() async {
    var library = await buildLibrary('''
class C {
  const C() : this.named(1, 'bbb');
  const C.named(int a, String b);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @24
                  period: . @28
                  constructorName: SimpleIdentifier
                    token: named @29
                    staticElement: <testLibraryFragment>::@class::C::@constructor::named
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @34
                    arguments
                      IntegerLiteral
                        literal: 1 @35
                        staticType: int
                      SimpleStringLiteral
                        literal: 'bbb' @38
                    rightParenthesis: ) @43
                  staticElement: <testLibraryFragment>::@class::C::@constructor::named
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::named
            const named @56
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 55
              nameEnd: 61
              parameters
                requiredPositional a @66
                  type: int
                requiredPositional b @76
                  type: String
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_thisInvocation_namedExpression() async {
    var library = await buildLibrary('''
class C {
  const C() : this.named(1, b: 2);
  const C.named(a, {int b});
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @24
                  period: . @28
                  constructorName: SimpleIdentifier
                    token: named @29
                    staticElement: <testLibraryFragment>::@class::C::@constructor::named
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @34
                    arguments
                      IntegerLiteral
                        literal: 1 @35
                        staticType: int
                      NamedExpression
                        name: Label
                          label: SimpleIdentifier
                            token: b @38
                            staticElement: <testLibraryFragment>::@class::C::@constructor::named::@parameter::b
                            staticType: null
                          colon: : @39
                        expression: IntegerLiteral
                          literal: 2 @41
                          staticType: int
                    rightParenthesis: ) @42
                  staticElement: <testLibraryFragment>::@class::C::@constructor::named
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::named
            const named @55
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 54
              nameEnd: 60
              parameters
                requiredPositional a @61
                  type: dynamic
                optionalNamed default b @69
                  reference: <testLibraryFragment>::@class::C::@constructor::named::@parameter::b
                  type: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_initializers_thisInvocation_unnamed() async {
    var library = await buildLibrary('''
class C {
  const C.named() : this(1, 'bbb');
  const C(int a, String b);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const named @20
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 19
              nameEnd: 25
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @30
                  argumentList: ArgumentList
                    leftParenthesis: ( @34
                    arguments
                      IntegerLiteral
                        literal: 1 @35
                        staticType: int
                      SimpleStringLiteral
                        literal: 'bbb' @38
                    rightParenthesis: ) @43
                  staticElement: <testLibraryFragment>::@class::C::@constructor::new
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::new
            const @54
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional a @60
                  type: int
                requiredPositional b @70
                  type: String
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_explicitType_function() async {
    var library = await buildLibrary('''
class A {
  A(Object? a);
}

class B extends A {
  B(int super.a<T extends num>(T d)?);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @22
                  type: Object?
        class B @35
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @51
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional final super.a @63
                  type: int Function<T extends num>(T)?
                  typeParameters
                    covariant T @65
                      bound: num
                  parameters
                    requiredPositional d @82
                      type: T
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_explicitType_interface() async {
    var library = await buildLibrary('''
class A {
  A(num a);
}

class B extends A {
  B(int super.a);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @18
                  type: num
        class B @31
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @47
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional final super.a @59
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_explicitType_interface_nullable() async {
    var library = await buildLibrary('''
class A {
  A(num? a);
}

class B extends A {
  B(int? super.a);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @19
                  type: num?
        class B @32
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @48
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional final super.a @61
                  type: int?
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_invalid_topFunction() async {
    var library = await buildLibrary('''
void f(super.a) {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      functions
        f @5
          reference: <testLibraryFragment>::@function::f
          enclosingElement: <testLibraryFragment>
          parameters
            requiredPositional final super.a @13
              type: dynamic
              superConstructorParameter: <null>
          returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_optionalNamed() async {
    var library = await buildLibrary('''
class A {
  A({required int a, required double b});
}

class B extends A {
  B({String o1, super.a, String o2, super.b}) : super();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredNamed default a @28
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                  type: int
                requiredNamed default b @47
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::b
                  type: double
        class B @61
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @77
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                optionalNamed default o1 @87
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::o1
                  type: String
                optionalNamed default final super.a @97
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::a
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                optionalNamed default o2 @107
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::o2
                  type: String
                optionalNamed default final super.b @117
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::b
                  type: double
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::b
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_optionalNamed_defaultValue() async {
    var library = await buildLibrary('''
class A {
  A({int a = 0});
}

class B extends A {
  B({super.a});
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                optionalNamed default a @19
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 0 @23
                      staticType: int
        class B @37
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @53
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                optionalNamed default final hasDefaultValue super.a @62
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::a
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_optionalNamed_unresolved() async {
    var library = await buildLibrary('''
class A {
  A({required int a});
}

class B extends A {
  B({super.b});
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredNamed default a @28
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                  type: int
        class B @42
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @58
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                optionalNamed default final super.b @67
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::b
                  type: dynamic
                  superConstructorParameter: <null>
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_optionalNamed_unresolved2() async {
    var library = await buildLibrary('''
class A {
  A(int a);
}

class B extends A {
  B({super.a});
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @18
                  type: int
        class B @31
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @47
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                optionalNamed default final super.a @56
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::a
                  type: dynamic
                  superConstructorParameter: <null>
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_optionalPositional() async {
    var library = await buildLibrary('''
class A {
  A(int a, double b);
}

class B extends A {
  B([String o1, super.a, String o2, super.b]) : super();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @18
                  type: int
                requiredPositional b @28
                  type: double
        class B @41
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @57
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                optionalPositional default o1 @67
                  type: String
                optionalPositional default final super.a @77
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                optionalPositional default o2 @87
                  type: String
                optionalPositional default final super.b @97
                  type: double
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::b
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_requiredNamed() async {
    var library = await buildLibrary('''
class A {
  A({required int a, required double b});
}

class B extends A {
  B({
    required String o1,
    required super.a,
    required String o2,
    required super.b,
  }) : super();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredNamed default a @28
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                  type: int
                requiredNamed default b @47
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::b
                  type: double
        class B @61
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @77
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredNamed default o1 @101
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::o1
                  type: String
                requiredNamed default final super.a @124
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::a
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                requiredNamed default o2 @147
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::o2
                  type: String
                requiredNamed default final super.b @170
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::b
                  type: double
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::b
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_requiredNamed_defaultValue() async {
    var library = await buildLibrary('''
class A {
  A({int a = 0});
}

class B extends A {
  B({required super.a});
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                optionalNamed default a @19
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 0 @23
                      staticType: int
        class B @37
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @53
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredNamed default final super.a @71
                  reference: <testLibraryFragment>::@class::B::@constructor::new::@parameter::a
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_requiredPositional() async {
    var library = await buildLibrary('''
class A {
  A(int a, double b);
}

class B extends A {
  B(String o1, super.a, String o2, super.b) : super();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @18
                  type: int
                requiredPositional b @28
                  type: double
        class B @41
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @57
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional o1 @66
                  type: String
                requiredPositional final super.a @76
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                requiredPositional o2 @86
                  type: String
                requiredPositional final super.b @96
                  type: double
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::b
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_requiredPositional_inferenceOrder() async {
    // It is important that `B` is declared after `C`, so that we check that
    // inference happens in order - first `B`, then `C`.
    var library = await buildLibrary('''
abstract class A {
  A(int a);
}

class C extends B {
  C(super.a);
}

class B extends A {
  B(super.a);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class A @15
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @21
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @27
                  type: int
        class C @40
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: B
          constructors
            @56
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final super.a @64
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::B::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::B::@constructor::new
        class B @77
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @93
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional final super.a @101
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_requiredPositional_inferenceOrder_generic() async {
    // It is important that `C` is declared before `B`, so that we check that
    // inference happens in order - first `B`, then `C`.
    var library = await buildLibrary('''
class A {
  A(int a);
}

class C extends B<String> {
  C(super.a);
}

class B<T> extends A {
  B(super.a);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional a @18
                  type: int
        class C @31
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: B<String>
          constructors
            @55
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final super.a @63
                  type: int
                  superConstructorParameter: SuperFormalParameterMember
                    base: <testLibraryFragment>::@class::B::@constructor::new::@parameter::a
                    substitution: {T: String}
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::B::@constructor::new
                substitution: {T: String}
        class B @76
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @78
              defaultType: dynamic
          supertype: A
          constructors
            @95
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional final super.a @103
                  type: int
                  superConstructorParameter: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_requiredPositional_unresolved() async {
    var library = await buildLibrary('''
class A {}

class B extends A {
  B(super.a);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @18
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @34
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional final super.a @42
                  type: dynamic
                  superConstructorParameter: <null>
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_parameters_super_requiredPositional_unresolved2() async {
    var library = await buildLibrary('''
class A {
  A({required int a})
}

class B extends A {
  B(super.a);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredNamed default a @28
                  reference: <testLibraryFragment>::@class::A::@constructor::new::@parameter::a
                  type: int
        class B @41
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @57
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional final super.a @65
                  type: dynamic
                  superConstructorParameter: <null>
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_params() async {
    var library = await buildLibrary('class C { C(x, int y); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            @10
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional x @12
                  type: dynamic
                requiredPositional y @19
                  type: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_named() async {
    var library = await buildLibrary('''
class C {
  factory C() = D.named;
  C._();
}
class D extends C {
  D.named() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @20
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: <testLibraryFragment>::@class::D::@constructor::named
            _ @39
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 38
              nameEnd: 40
        class D @52
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          supertype: C
          constructors
            named @70
              reference: <testLibraryFragment>::@class::D::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::D
              periodOffset: 69
              nameEnd: 75
              superConstructor: <testLibraryFragment>::@class::C::@constructor::_
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_named_generic() async {
    var library = await buildLibrary('''
class C<T, U> {
  factory C() = D<U, T>.named;
  C._();
}
class D<T, U> extends C<U, T> {
  D.named() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
            covariant U @11
              defaultType: dynamic
          constructors
            factory @26
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::D::@constructor::named
                substitution: {T: U, U: T}
            _ @51
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 50
              nameEnd: 52
        class D @64
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @66
              defaultType: dynamic
            covariant U @69
              defaultType: dynamic
          supertype: C<U, T>
          constructors
            named @94
              reference: <testLibraryFragment>::@class::D::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::D
              periodOffset: 93
              nameEnd: 99
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::C::@constructor::_
                substitution: {T: U, U: T}
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_named_generic_viaTypeAlias() async {
    var library = await buildLibrary('''
typedef A<T, U> = C<T, U>;
class B<T, U> {
  factory B() = A<U, T>.named;
  B._();
}
class C<T, U> extends A<U, T> {
  C.named() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @33
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @35
              defaultType: dynamic
            covariant U @38
              defaultType: dynamic
          constructors
            factory @53
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              redirectedConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::C::@constructor::named
                substitution: {T: U, U: T}
            _ @78
              reference: <testLibraryFragment>::@class::B::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::B
              periodOffset: 77
              nameEnd: 79
        class C @91
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @93
              defaultType: dynamic
            covariant U @96
              defaultType: dynamic
          supertype: C<U, T>
            alias: <testLibraryFragment>::@typeAlias::A
              typeArguments
                U
                T
          constructors
            named @121
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 120
              nameEnd: 126
      typeAliases
        A @8
          reference: <testLibraryFragment>::@typeAlias::A
          typeParameters
            covariant T @10
              defaultType: dynamic
            covariant U @13
              defaultType: dynamic
          aliasedType: C<T, U>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_named_imported() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D extends C {
  D.named() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart';
class C {
  factory C() = D.named;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @25
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @39
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: package:test/foo.dart::<fragment>::@class::D::@constructor::named
            _ @58
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 57
              nameEnd: 59
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
''');
  }

  test_class_constructor_redirected_factory_named_imported_generic() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D<T, U> extends C<U, T> {
  D.named() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart';
class C<T, U> {
  factory C() = D<U, T>.named;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @25
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @27
              defaultType: dynamic
            covariant U @30
              defaultType: dynamic
          constructors
            factory @45
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: ConstructorMember
                base: package:test/foo.dart::<fragment>::@class::D::@constructor::named
                substitution: {T: U, U: T}
            _ @70
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 69
              nameEnd: 71
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
''');
  }

  test_class_constructor_redirected_factory_named_prefixed() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D extends C {
  D.named() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart' as foo;
class C {
  factory C() = foo.D.named;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart as foo @21
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  prefixes
    foo @21
      reference: <testLibraryFragment>::@prefix::foo
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart as foo @21
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      libraryImportPrefixes
        foo @21
          reference: <testLibraryFragment>::@prefix::foo
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @32
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @46
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: package:test/foo.dart::<fragment>::@class::D::@constructor::named
            _ @69
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 68
              nameEnd: 70
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
      prefixes
        foo
          reference: <testLibraryFragment>::@prefix::foo
''');
  }

  test_class_constructor_redirected_factory_named_prefixed_generic() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D<T, U> extends C<U, T> {
  D.named() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart' as foo;
class C<T, U> {
  factory C() = foo.D<U, T>.named;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart as foo @21
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  prefixes
    foo @21
      reference: <testLibraryFragment>::@prefix::foo
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart as foo @21
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      libraryImportPrefixes
        foo @21
          reference: <testLibraryFragment>::@prefix::foo
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @32
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @34
              defaultType: dynamic
            covariant U @37
              defaultType: dynamic
          constructors
            factory @52
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: ConstructorMember
                base: package:test/foo.dart::<fragment>::@class::D::@constructor::named
                substitution: {T: U, U: T}
            _ @81
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 80
              nameEnd: 82
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
      prefixes
        foo
          reference: <testLibraryFragment>::@prefix::foo
''');
  }

  test_class_constructor_redirected_factory_named_unresolved_class() async {
    var library = await buildLibrary('''
class C<E> {
  factory C() = D.named<E>;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant E @8
              defaultType: dynamic
          constructors
            factory @23
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_named_unresolved_constructor() async {
    var library = await buildLibrary('''
class D {}
class C<E> {
  factory C() = D.named<E>;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class D @6
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class C @17
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant E @19
              defaultType: dynamic
          constructors
            factory @34
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_unnamed() async {
    var library = await buildLibrary('''
class C {
  factory C() = D;
  C._();
}
class D extends C {
  D() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @20
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: <testLibraryFragment>::@class::D::@constructor::new
            _ @33
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 32
              nameEnd: 34
        class D @46
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          supertype: C
          constructors
            @62
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
              superConstructor: <testLibraryFragment>::@class::C::@constructor::_
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_unnamed_generic() async {
    var library = await buildLibrary('''
class C<T, U> {
  factory C() = D<U, T>;
  C._();
}
class D<T, U> extends C<U, T> {
  D() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
            covariant U @11
              defaultType: dynamic
          constructors
            factory @26
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::D::@constructor::new
                substitution: {T: U, U: T}
            _ @45
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 44
              nameEnd: 46
        class D @58
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @60
              defaultType: dynamic
            covariant U @63
              defaultType: dynamic
          supertype: C<U, T>
          constructors
            @86
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::C::@constructor::_
                substitution: {T: U, U: T}
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_unnamed_generic_viaTypeAlias() async {
    var library = await buildLibrary('''
typedef A<T, U> = C<T, U>;
class B<T, U> {
  factory B() = A<U, T>;
  B_();
}
class C<T, U> extends B<U, T> {
  C() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @33
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @35
              defaultType: dynamic
            covariant U @38
              defaultType: dynamic
          constructors
            factory @53
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              redirectedConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::C::@constructor::new
                substitution: {T: U, U: T}
          methods
            abstract B_ @70
              reference: <testLibraryFragment>::@class::B::@method::B_
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: dynamic
        class C @84
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @86
              defaultType: dynamic
            covariant U @89
              defaultType: dynamic
          supertype: B<U, T>
          constructors
            @112
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
      typeAliases
        A @8
          reference: <testLibraryFragment>::@typeAlias::A
          typeParameters
            covariant T @10
              defaultType: dynamic
            covariant U @13
              defaultType: dynamic
          aliasedType: C<T, U>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_unnamed_imported() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D extends C {
  D() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart';
class C {
  factory C() = D;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @25
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @39
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: package:test/foo.dart::<fragment>::@class::D::@constructor::new
            _ @52
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 51
              nameEnd: 53
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
''');
  }

  test_class_constructor_redirected_factory_unnamed_imported_generic() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D<T, U> extends C<U, T> {
  D() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart';
class C<T, U> {
  factory C() = D<U, T>;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @25
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @27
              defaultType: dynamic
            covariant U @30
              defaultType: dynamic
          constructors
            factory @45
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: ConstructorMember
                base: package:test/foo.dart::<fragment>::@class::D::@constructor::new
                substitution: {T: U, U: T}
            _ @64
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 63
              nameEnd: 65
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
''');
  }

  test_class_constructor_redirected_factory_unnamed_imported_viaTypeAlias() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
typedef A = B;
class B extends C {
  B() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart';
class C {
  factory C() = A;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @25
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @39
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: package:test/foo.dart::<fragment>::@class::B::@constructor::new
            _ @52
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 51
              nameEnd: 53
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
''');
  }

  test_class_constructor_redirected_factory_unnamed_prefixed() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D extends C {
  D() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart' as foo;
class C {
  factory C() = foo.D;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart as foo @21
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  prefixes
    foo @21
      reference: <testLibraryFragment>::@prefix::foo
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart as foo @21
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      libraryImportPrefixes
        foo @21
          reference: <testLibraryFragment>::@prefix::foo
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @32
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @46
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: package:test/foo.dart::<fragment>::@class::D::@constructor::new
            _ @63
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 62
              nameEnd: 64
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
      prefixes
        foo
          reference: <testLibraryFragment>::@prefix::foo
''');
  }

  test_class_constructor_redirected_factory_unnamed_prefixed_generic() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
class D<T, U> extends C<U, T> {
  D() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart' as foo;
class C<T, U> {
  factory C() = foo.D<U, T>;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart as foo @21
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  prefixes
    foo @21
      reference: <testLibraryFragment>::@prefix::foo
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart as foo @21
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      libraryImportPrefixes
        foo @21
          reference: <testLibraryFragment>::@prefix::foo
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @32
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @34
              defaultType: dynamic
            covariant U @37
              defaultType: dynamic
          constructors
            factory @52
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: ConstructorMember
                base: package:test/foo.dart::<fragment>::@class::D::@constructor::new
                substitution: {T: U, U: T}
            _ @75
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 74
              nameEnd: 76
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
      prefixes
        foo
          reference: <testLibraryFragment>::@prefix::foo
''');
  }

  test_class_constructor_redirected_factory_unnamed_prefixed_viaTypeAlias() async {
    addSource('$testPackageLibPath/foo.dart', '''
import 'test.dart';
typedef A = B;
class B extends C {
  B() : super._();
}
''');
    var library = await buildLibrary('''
import 'foo.dart' as foo;
class C {
  factory C() = foo.A;
  C._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/foo.dart as foo @21
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  prefixes
    foo @21
      reference: <testLibraryFragment>::@prefix::foo
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/foo.dart as foo @21
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      libraryImportPrefixes
        foo @21
          reference: <testLibraryFragment>::@prefix::foo
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @32
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            factory @46
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: package:test/foo.dart::<fragment>::@class::B::@constructor::new
            _ @63
              reference: <testLibraryFragment>::@class::C::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 62
              nameEnd: 64
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/foo.dart
      prefixes
        foo
          reference: <testLibraryFragment>::@prefix::foo
''');
  }

  test_class_constructor_redirected_factory_unnamed_unresolved() async {
    var library = await buildLibrary('''
class C<E> {
  factory C() = D<E>;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant E @8
              defaultType: dynamic
          constructors
            factory @23
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_factory_unnamed_viaTypeAlias() async {
    var library = await buildLibrary('''
typedef A = C;
class B {
  factory B() = A;
  B._();
}
class C extends B {
  C() : super._();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @21
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          constructors
            factory @35
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::new
            _ @48
              reference: <testLibraryFragment>::@class::B::@constructor::_
              enclosingElement: <testLibraryFragment>::@class::B
              periodOffset: 47
              nameEnd: 49
        class C @61
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: B
          constructors
            @77
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::B::@constructor::_
      typeAliases
        A @8
          reference: <testLibraryFragment>::@typeAlias::A
          aliasedType: C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_thisInvocation_named() async {
    var library = await buildLibrary('''
class C {
  const C.named();
  const C() : this.named();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const named @20
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 19
              nameEnd: 25
            const @37
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @43
                  period: . @47
                  constructorName: SimpleIdentifier
                    token: named @48
                    staticElement: <testLibraryFragment>::@class::C::@constructor::named
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @53
                    rightParenthesis: ) @54
                  staticElement: <testLibraryFragment>::@class::C::@constructor::named
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::named
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_thisInvocation_named_generic() async {
    var library = await buildLibrary('''
class C<T> {
  const C.named();
  const C() : this.named();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            const named @23
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 22
              nameEnd: 28
            const @40
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @46
                  period: . @50
                  constructorName: SimpleIdentifier
                    token: named @51
                    staticElement: <testLibraryFragment>::@class::C::@constructor::named
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @56
                    rightParenthesis: ) @57
                  staticElement: <testLibraryFragment>::@class::C::@constructor::named
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::named
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_thisInvocation_named_notConst() async {
    var library = await buildLibrary('''
class C {
  C.named();
  C() : this.named();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            named @14
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 13
              nameEnd: 19
            @25
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::named
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_thisInvocation_unnamed() async {
    var library = await buildLibrary('''
class C {
  const C();
  const C.named() : this();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            const @18
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
            const named @33
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 32
              nameEnd: 38
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @43
                  argumentList: ArgumentList
                    leftParenthesis: ( @47
                    rightParenthesis: ) @48
                  staticElement: <testLibraryFragment>::@class::C::@constructor::new
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_thisInvocation_unnamed_generic() async {
    var library = await buildLibrary('''
class C<T> {
  const C();
  const C.named() : this();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            const @21
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
            const named @36
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 35
              nameEnd: 41
              constantInitializers
                RedirectingConstructorInvocation
                  thisKeyword: this @46
                  argumentList: ArgumentList
                    leftParenthesis: ( @50
                    rightParenthesis: ) @51
                  staticElement: <testLibraryFragment>::@class::C::@constructor::new
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_redirected_thisInvocation_unnamed_notConst() async {
    var library = await buildLibrary('''
class C {
  C();
  C.named() : this();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
            named @21
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 20
              nameEnd: 26
              redirectedConstructor: <testLibraryFragment>::@class::C::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_superConstructor_generic_named() async {
    var library = await buildLibrary('''
class A<T> {
  A.named(T a);
}
class B extends A<int> {
  B() : super.named(0);
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            named @17
              reference: <testLibraryFragment>::@class::A::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 16
              nameEnd: 22
              parameters
                requiredPositional a @25
                  type: T
        class B @37
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A<int>
          constructors
            @58
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::A::@constructor::named
                substitution: {T: int}
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_superConstructor_notGeneric_named() async {
    var library = await buildLibrary('''
class A {
  A.named();
}
class B extends A {
  B() : super.named();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            named @14
              reference: <testLibraryFragment>::@class::A::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 13
              nameEnd: 19
        class B @31
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @47
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::named
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_superConstructor_notGeneric_unnamed_explicit() async {
    var library = await buildLibrary('''
class A {}
class B extends A {
  B() : super();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @17
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @33
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_superConstructor_notGeneric_unnamed_implicit() async {
    var library = await buildLibrary('''
class A {}
class B extends A {
  B();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @17
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            @33
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_superConstructor_notGeneric_unnamed_implicit2() async {
    var library = await buildLibrary('''
class A {}
class B extends A {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @17
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_unnamed_implicit() async {
    var library = await buildLibrary('class C {}');
    configuration.withDisplayName = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              displayName: C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_withCycles_const() async {
    var library = await buildLibrary('''
class C {
  final x;
  const C() : x = const D();
}
class D {
  final x;
  const D() : x = const C();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            const @29
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: x @35
                    staticElement: <testLibraryFragment>::@class::C::@field::x
                    staticType: null
                  equals: = @37
                  expression: InstanceCreationExpression
                    keyword: const @39
                    constructorName: ConstructorName
                      type: NamedType
                        name: D @45
                        element: <testLibraryFragment>::@class::D
                        type: D
                      staticElement: <testLibraryFragment>::@class::D::@constructor::new
                    argumentList: ArgumentList
                      leftParenthesis: ( @46
                      rightParenthesis: ) @47
                    staticType: D
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
        class D @58
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          fields
            final x @70
              reference: <testLibraryFragment>::@class::D::@field::x
              enclosingElement: <testLibraryFragment>::@class::D
              type: dynamic
          constructors
            const @81
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: x @87
                    staticElement: <testLibraryFragment>::@class::D::@field::x
                    staticType: null
                  equals: = @89
                  expression: InstanceCreationExpression
                    keyword: const @91
                    constructorName: ConstructorName
                      type: NamedType
                        name: C @97
                        element: <testLibraryFragment>::@class::C
                        type: C
                      staticElement: <testLibraryFragment>::@class::C::@constructor::new
                    argumentList: ArgumentList
                      leftParenthesis: ( @98
                      rightParenthesis: ) @99
                    staticType: C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::D::@getter::x
              enclosingElement: <testLibraryFragment>::@class::D
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructor_withCycles_nonConst() async {
    var library = await buildLibrary('''
class C {
  final x;
  C() : x = new D();
}
class D {
  final x;
  D() : x = new C();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            @23
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
        class D @50
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          fields
            final x @62
              reference: <testLibraryFragment>::@class::D::@field::x
              enclosingElement: <testLibraryFragment>::@class::D
              type: dynamic
          constructors
            @67
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::D::@getter::x
              enclosingElement: <testLibraryFragment>::@class::D
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructors_named() async {
    var library = await buildLibrary('''
class C {
  C.foo();
}
''');
    configuration.withDisplayName = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            foo @14
              reference: <testLibraryFragment>::@class::C::@constructor::foo
              enclosingElement: <testLibraryFragment>::@class::C
              displayName: C.foo
              periodOffset: 13
              nameEnd: 17
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructors_unnamed() async {
    var library = await buildLibrary('''
class C {
  C();
}
''');
    configuration.withDisplayName = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              displayName: C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_constructors_unnamed_new() async {
    var library = await buildLibrary('''
class C {
  C.new();
}
''');
    configuration.withDisplayName = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            @14
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              displayName: C
              periodOffset: 13
              nameEnd: 17
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_documented() async {
    var library = await buildLibrary('''
/**
 * Docs
 */
class C {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @22
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * Docs\n */
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_documented_mix() async {
    var library = await buildLibrary('''
/**
 * aaa
 */
/**
 * bbb
 */
class A {}

/**
 * aaa
 */
/// bbb
/// ccc
class B {}

/// aaa
/// bbb
/**
 * ccc
 */
class C {}

/// aaa
/// bbb
/**
 * ccc
 */
/// ddd
class D {}

/**
 * aaa
 */
// bbb
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @36
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * bbb\n */
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @79
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          documentationComment: /// bbb\n/// ccc
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
        class C @122
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * ccc\n */
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class D @173
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          documentationComment: /// ddd
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @207
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * aaa\n */
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_documented_tripleSlash() async {
    var library = await buildLibrary('''
/// first
/// second
/// third
class C {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @37
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /// first\n/// second\n/// third
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_documented_with_references() async {
    var library = await buildLibrary('''
/**
 * Docs referring to [D] and [E]
 */
class C {}

class D {}
class E {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @47
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * Docs referring to [D] and [E]\n */
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class D @59
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @70
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_documented_with_windows_line_endings() async {
    var library = await buildLibrary('/**\r\n * Docs\r\n */\r\nclass C {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @25
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * Docs\n */
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_documented_withLeadingNotDocumentation() async {
    var library = await buildLibrary('''
// Extra comment so doc comment offset != 0
/**
 * Docs
 */
class C {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @66
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * Docs\n */
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_documented_withMetadata() async {
    var library = await buildLibrary('''
/// Comment 1
/// Comment 2
@Annotation()
class BeforeMeta {}

/// Comment 1
/// Comment 2
@Annotation.named()
class BeforeMetaNamed {}

@Annotation()
/// Comment 1
/// Comment 2
class AfterMeta {}

/// Comment 1
@Annotation()
/// Comment 2
class AroundMeta {}

/// Doc comment.
@Annotation()
// Not doc comment.
class DocBeforeMetaNotDocAfter {}

class Annotation {
  const Annotation();
  const Annotation.named();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class BeforeMeta @48
          reference: <testLibraryFragment>::@class::BeforeMeta
          enclosingElement: <testLibraryFragment>
          documentationComment: /// Comment 1\n/// Comment 2
          metadata
            Annotation
              atSign: @ @28
              name: SimpleIdentifier
                token: Annotation @29
                staticElement: <testLibraryFragment>::@class::Annotation
                staticType: null
              arguments: ArgumentList
                leftParenthesis: ( @39
                rightParenthesis: ) @40
              element: <testLibraryFragment>::@class::Annotation::@constructor::new
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::BeforeMeta::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::BeforeMeta
        class BeforeMetaNamed @117
          reference: <testLibraryFragment>::@class::BeforeMetaNamed
          enclosingElement: <testLibraryFragment>
          documentationComment: /// Comment 1\n/// Comment 2
          metadata
            Annotation
              atSign: @ @91
              name: PrefixedIdentifier
                prefix: SimpleIdentifier
                  token: Annotation @92
                  staticElement: <testLibraryFragment>::@class::Annotation
                  staticType: null
                period: . @102
                identifier: SimpleIdentifier
                  token: named @103
                  staticElement: <testLibraryFragment>::@class::Annotation::@constructor::named
                  staticType: null
                staticElement: <testLibraryFragment>::@class::Annotation::@constructor::named
                staticType: null
              arguments: ArgumentList
                leftParenthesis: ( @108
                rightParenthesis: ) @109
              element: <testLibraryFragment>::@class::Annotation::@constructor::named
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::BeforeMetaNamed::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::BeforeMetaNamed
        class AfterMeta @185
          reference: <testLibraryFragment>::@class::AfterMeta
          enclosingElement: <testLibraryFragment>
          documentationComment: /// Comment 1\n/// Comment 2
          metadata
            Annotation
              atSign: @ @137
              name: SimpleIdentifier
                token: Annotation @138
                staticElement: <testLibraryFragment>::@class::Annotation
                staticType: null
              arguments: ArgumentList
                leftParenthesis: ( @148
                rightParenthesis: ) @149
              element: <testLibraryFragment>::@class::Annotation::@constructor::new
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::AfterMeta::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::AfterMeta
        class AroundMeta @247
          reference: <testLibraryFragment>::@class::AroundMeta
          enclosingElement: <testLibraryFragment>
          documentationComment: /// Comment 2
          metadata
            Annotation
              atSign: @ @213
              name: SimpleIdentifier
                token: Annotation @214
                staticElement: <testLibraryFragment>::@class::Annotation
                staticType: null
              arguments: ArgumentList
                leftParenthesis: ( @224
                rightParenthesis: ) @225
              element: <testLibraryFragment>::@class::Annotation::@constructor::new
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::AroundMeta::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::AroundMeta
        class DocBeforeMetaNotDocAfter @319
          reference: <testLibraryFragment>::@class::DocBeforeMetaNotDocAfter
          enclosingElement: <testLibraryFragment>
          documentationComment: /// Doc comment.
          metadata
            Annotation
              atSign: @ @279
              name: SimpleIdentifier
                token: Annotation @280
                staticElement: <testLibraryFragment>::@class::Annotation
                staticType: null
              arguments: ArgumentList
                leftParenthesis: ( @290
                rightParenthesis: ) @291
              element: <testLibraryFragment>::@class::Annotation::@constructor::new
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::DocBeforeMetaNotDocAfter::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::DocBeforeMetaNotDocAfter
        class Annotation @354
          reference: <testLibraryFragment>::@class::Annotation
          enclosingElement: <testLibraryFragment>
          constructors
            const @375
              reference: <testLibraryFragment>::@class::Annotation::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::Annotation
            const named @408
              reference: <testLibraryFragment>::@class::Annotation::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::Annotation
              periodOffset: 407
              nameEnd: 413
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_abstract() async {
    var library = await buildLibrary('''
abstract class C {
  abstract int i;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class C @15
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            abstract i @34
              reference: <testLibraryFragment>::@class::C::@field::i
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic abstract get i @-1
              reference: <testLibraryFragment>::@class::C::@getter::i
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic abstract set i= @-1
              reference: <testLibraryFragment>::@class::C::@setter::i
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _i @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_const() async {
    var library = await buildLibrary('class C { static const int i = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static const i @27
              reference: <testLibraryFragment>::@class::C::@field::i
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 0 @31
                  staticType: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get i @-1
              reference: <testLibraryFragment>::@class::C::@getter::i
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_const_late() async {
    var library =
        await buildLibrary('class C { static late const int i = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static late const i @32
              reference: <testLibraryFragment>::@class::C::@field::i
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 0 @36
                  staticType: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get i @-1
              reference: <testLibraryFragment>::@class::C::@getter::i
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_covariant() async {
    var library = await buildLibrary('''
class C {
  covariant int x;
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            covariant x @26
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional covariant _x @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_documented() async {
    var library = await buildLibrary('''
class C {
  /**
   * Docs
   */
  var x;
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @38
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              documentationComment: /**\n   * Docs\n   */
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_duplicate_getter() async {
    var library = await buildLibrary('''
class C {
  int foo = 0;
  int get foo => 0;
}
''');
    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            foo @16
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              id: field_1
              getter: getter_1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::C::@getter::foo::@def::0
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::C::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
            get foo @35
              reference: <testLibraryFragment>::@class::C::@getter::foo::@def::1
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
              id: getter_1
              variable: field_1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_duplicate_setter() async {
    var library = await buildLibrary('''
class C {
  int foo = 0;
  set foo(int _) {}
}
''');
    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            foo @16
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              id: field_1
              setter: setter_1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::C::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::C::@setter::foo::@def::0
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
            set foo= @31
              reference: <testLibraryFragment>::@class::C::@setter::foo::@def::1
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _ @39
                  type: int
              returnType: void
              id: setter_1
              variable: field_1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_external() async {
    var library = await buildLibrary('''
abstract class C {
  external int i;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class C @15
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            external i @34
              reference: <testLibraryFragment>::@class::C::@field::i
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get i @-1
              reference: <testLibraryFragment>::@class::C::@getter::i
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set i= @-1
              reference: <testLibraryFragment>::@class::C::@setter::i
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _i @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_final_hasInitializer_hasConstConstructor() async {
    var library = await buildLibrary('''
class C {
  final x = 42;
  const C();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
              constantInitializer
                IntegerLiteral
                  literal: 42 @22
                  staticType: int
          constructors
            const @34
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_final_hasInitializer_hasConstConstructor_genericFunctionType() async {
    var library = await buildLibrary('''
class A<T> {
  const A();
}
class B {
  final f = const A<int Function(double a)>();
  const B();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            const @21
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @34
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          fields
            final f @46
              reference: <testLibraryFragment>::@class::B::@field::f
              enclosingElement: <testLibraryFragment>::@class::B
              type: A<int Function(double)>
              shouldUseTypeForInitializerInference: false
              constantInitializer
                InstanceCreationExpression
                  keyword: const @50
                  constructorName: ConstructorName
                    type: NamedType
                      name: A @56
                      typeArguments: TypeArgumentList
                        leftBracket: < @57
                        arguments
                          GenericFunctionType
                            returnType: NamedType
                              name: int @58
                              element: dart:core::<fragment>::@class::int
                              type: int
                            functionKeyword: Function @62
                            parameters: FormalParameterList
                              leftParenthesis: ( @70
                              parameter: SimpleFormalParameter
                                type: NamedType
                                  name: double @71
                                  element: dart:core::<fragment>::@class::double
                                  type: double
                                name: a @78
                                declaredElement: a@78
                                  type: double
                              rightParenthesis: ) @79
                            declaredElement: GenericFunctionTypeElement
                              parameters
                                a
                                  kind: required positional
                                  type: double
                              returnType: int
                              type: int Function(double)
                            type: int Function(double)
                        rightBracket: > @80
                      element: <testLibraryFragment>::@class::A
                      type: A<int Function(double)>
                    staticElement: ConstructorMember
                      base: <testLibraryFragment>::@class::A::@constructor::new
                      substitution: {T: int Function(double)}
                  argumentList: ArgumentList
                    leftParenthesis: ( @81
                    rightParenthesis: ) @82
                  staticType: A<int Function(double)>
          constructors
            const @93
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
          accessors
            synthetic get f @-1
              reference: <testLibraryFragment>::@class::B::@getter::f
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: A<int Function(double)>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_final_hasInitializer_noConstConstructor() async {
    var library = await buildLibrary('''
class C {
  final x = 42;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_final_withSetter() async {
    var library = await buildLibrary(r'''
class A {
  final int foo;
  A(this.foo);
  set foo(int newValue) {}
}
''');
    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final foo @22
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              getter: getter_0
              setter: setter_0
          constructors
            @29
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional final this.foo @36
                  type: int
                  field: <testLibraryFragment>::@class::A::@field::foo
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
            set foo= @48
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional newValue @56
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_formal_param_inferred_type_implicit() async {
    var library = await buildLibrary('class C extends D { var v; C(this.v); }'
        ' abstract class D { int get v; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          fields
            v @24
              reference: <testLibraryFragment>::@class::C::@field::v
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            @27
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.v @34
                  type: int
                  field: <testLibraryFragment>::@class::C::@field::v
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
          accessors
            synthetic get v @-1
              reference: <testLibraryFragment>::@class::C::@getter::v
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set v= @-1
              reference: <testLibraryFragment>::@class::C::@setter::v
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _v @-1
                  type: int
              returnType: void
        abstract class D @55
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          fields
            synthetic v @-1
              reference: <testLibraryFragment>::@class::D::@field::v
              enclosingElement: <testLibraryFragment>::@class::D
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
          accessors
            abstract get v @67
              reference: <testLibraryFragment>::@class::D::@getter::v
              enclosingElement: <testLibraryFragment>::@class::D
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_implicit_type() async {
    var library = await buildLibrary('class C { var x; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_implicit_type_late() async {
    var library = await buildLibrary('class C { late var x; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            late x @19
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_inferred_type_nonStatic_explicit_initialized() async {
    var library = await buildLibrary('class C { num v = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            v @14
              reference: <testLibraryFragment>::@class::C::@field::v
              enclosingElement: <testLibraryFragment>::@class::C
              type: num
              shouldUseTypeForInitializerInference: true
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get v @-1
              reference: <testLibraryFragment>::@class::C::@getter::v
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: num
            synthetic set v= @-1
              reference: <testLibraryFragment>::@class::C::@setter::v
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _v @-1
                  type: num
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_inferred_type_nonStatic_implicit_initialized() async {
    var library = await buildLibrary('class C { var v = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            v @14
              reference: <testLibraryFragment>::@class::C::@field::v
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get v @-1
              reference: <testLibraryFragment>::@class::C::@getter::v
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set v= @-1
              reference: <testLibraryFragment>::@class::C::@setter::v
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _v @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_inferred_type_nonStatic_implicit_uninitialized() async {
    var library = await buildLibrary(
        'class C extends D { var v; } abstract class D { int get v; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          fields
            v @24
              reference: <testLibraryFragment>::@class::C::@field::v
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
          accessors
            synthetic get v @-1
              reference: <testLibraryFragment>::@class::C::@getter::v
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set v= @-1
              reference: <testLibraryFragment>::@class::C::@setter::v
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _v @-1
                  type: int
              returnType: void
        abstract class D @44
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          fields
            synthetic v @-1
              reference: <testLibraryFragment>::@class::D::@field::v
              enclosingElement: <testLibraryFragment>::@class::D
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
          accessors
            abstract get v @56
              reference: <testLibraryFragment>::@class::D::@getter::v
              enclosingElement: <testLibraryFragment>::@class::D
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_inferred_type_nonStatic_inherited_resolveInitializer() async {
    var library = await buildLibrary(r'''
const a = 0;
abstract class A {
  const A();
  List<int> get f;
}
class B extends A {
  const B();
  final f = [a];
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class A @28
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic f @-1
              reference: <testLibraryFragment>::@class::A::@field::f
              enclosingElement: <testLibraryFragment>::@class::A
              type: List<int>
          constructors
            const @40
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            abstract get f @61
              reference: <testLibraryFragment>::@class::A::@getter::f
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: List<int>
        class B @72
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          fields
            final f @107
              reference: <testLibraryFragment>::@class::B::@field::f
              enclosingElement: <testLibraryFragment>::@class::B
              type: List<int>
              shouldUseTypeForInitializerInference: true
              constantInitializer
                ListLiteral
                  leftBracket: [ @111
                  elements
                    SimpleIdentifier
                      token: a @112
                      staticElement: <testLibraryFragment>::@getter::a
                      staticType: int
                  rightBracket: ] @113
                  staticType: List<int>
          constructors
            const @94
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          accessors
            synthetic get f @-1
              reference: <testLibraryFragment>::@class::B::@getter::f
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: List<int>
      topLevelVariables
        static const a @6
          reference: <testLibraryFragment>::@topLevelVariable::a
          enclosingElement: <testLibraryFragment>
          type: int
          shouldUseTypeForInitializerInference: false
          constantInitializer
            IntegerLiteral
              literal: 0 @10
              staticType: int
      accessors
        synthetic static get a @-1
          reference: <testLibraryFragment>::@getter::a
          enclosingElement: <testLibraryFragment>
          returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_inferred_type_static_implicit_initialized() async {
    var library = await buildLibrary('class C { static var v = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static v @21
              reference: <testLibraryFragment>::@class::C::@field::v
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get v @-1
              reference: <testLibraryFragment>::@class::C::@getter::v
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic static set v= @-1
              reference: <testLibraryFragment>::@class::C::@setter::v
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _v @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_inheritedContextType_double() async {
    var library = await buildLibrary('''
abstract class A {
  const A();
  double get foo;
}
class B extends A {
  const B();
  final foo = 2;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class A @15
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: double
          constructors
            const @27
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            abstract get foo @45
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: double
        class B @58
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          fields
            final foo @93
              reference: <testLibraryFragment>::@class::B::@field::foo
              enclosingElement: <testLibraryFragment>::@class::B
              type: double
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 2 @99
                  staticType: double
          constructors
            const @80
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::B::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: double
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_hasGetter() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  int? get _foo => 0;
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
  fieldNameNonPromotabilityInfo
    _foo
      conflictingGetters
        <testLibraryFragment>::@class::B::@getter::_foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingGetters
        <testLibraryFragment>::@class::B::@getter::_foo
''');
  }

  test_class_field_isPromotable_hasGetter_abstract() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

abstract class B {
  int? get _foo;
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_hasGetter_inPart() async {
    newFile('$testPackageLibPath/a.dart', r'''
part of 'test.dart';
class B {
  int? get _foo => 0;
}
''');

    var library = await buildLibrary(r'''
part 'a.dart';
class A {
  final int? _foo;
  A(this._foo);
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @21
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @38
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingGetters
        <testLibrary>::@fragment::package:test/a.dart::@class::B::@getter::_foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
  fieldNameNonPromotabilityInfo
    _foo
      conflictingGetters
        <testLibrary>::@fragment::package:test/a.dart::@class::B::@getter::_foo
''');
  }

  test_class_field_isPromotable_hasGetter_static() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  static int? get _foo => 0;
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_hasNotFinalField() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  int? _foo;
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
  fieldNameNonPromotabilityInfo
    _foo
      conflictingFields
        <testLibraryFragment>::@class::B::@field::_foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingFields
        <testLibraryFragment>::@class::B::@field::_foo
''');
  }

  test_class_field_isPromotable_hasNotFinalField_static() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  static int? _foo;
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_hasSetter() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  set _field(int? _) {}
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_language217() async {
    var library = await buildLibrary(r'''
// @dart = 2.19
class A {
  final int? _foo;
  A(this._foo);
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @22
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @39
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_field() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  final int? _foo = 0;
}

/// Implicitly implements `_foo` as a getter that forwards to [noSuchMethod].
class C implements B {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_field_implementedInMixin() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

mixin M {
  final int? _foo = 0;
}

class B {
  final int? _foo = 0;
}

/// `_foo` is implemented in [M].
class C with M implements B {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(
      classNames: {'A', 'B'},
      mixinNames: {'M'},
    );
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
        class B @90
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @107
              reference: <testLibraryFragment>::@class::B::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::B
              type: int?
              shouldUseTypeForInitializerInference: true
      mixins
        mixin M @54
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
          fields
            final promotable _foo @71
              reference: <testLibraryFragment>::@mixin::M::@field::_foo
              enclosingElement: <testLibraryFragment>::@mixin::M
              type: int?
              shouldUseTypeForInitializerInference: true
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_field_implementedInSuperclass() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  final int? _foo = 0;
}

class C {
  final int? _foo = 0;
}

/// `_foo` is implemented in [B].
class D extends B implements C {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(
      classNames: {'A', 'B'},
    );
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
        class B @54
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @71
              reference: <testLibraryFragment>::@class::B::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::B
              type: int?
              shouldUseTypeForInitializerInference: true
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_field_inClassTypeAlias() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  final int? _foo = 0;
}

mixin M {
  dynamic noSuchMethod(Invocation invocation) {}
}

/// Implicitly implements `_foo` as a getter that forwards to [noSuchMethod].
class E = Object with M implements B;
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::E
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_field_inEnum() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B {
  final int? _foo = 0;
}

/// Implicitly implements `_foo` as a getter that forwards to [noSuchMethod].
enum E implements B {
  v;
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(
      classNames: {'A', 'B'},
    );
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
        class B @54
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @71
              reference: <testLibraryFragment>::@class::B::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::B
              type: int?
              shouldUseTypeForInitializerInference: true
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@enum::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@enum::E
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_getter() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

abstract class B {
  int? get _foo;
}

/// Implicitly implements `_foo` as a getter that forwards to [noSuchMethod].
class C implements B {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_inDifferentLibrary() async {
    newFile('$testPackageLibPath/a.dart', r'''
class B {
  int? get _foo => 0;
}
''');

    var library = await buildLibrary(r'''
import 'a.dart';

class A {
  final int? _foo;
  A(this._foo);
}

/// Has a noSuchMethod thrower for B._field, but since private names in
/// different libraries are distinct, this has no effect on promotion of
/// C._field.
class C implements B {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(
      classNames: {'A'},
    );
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class A @24
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @41
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/a.dart
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_inheritedInterface() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

class B extends A {
  A(super.value);
}

/// Implicitly implements `_foo` as a getter that forwards to [noSuchMethod].
class C implements B {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_mixedInterface() async {
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

mixin M {
  final int? _foo = 0;
}

class B with M {}

/// Implicitly implements `_foo` as a getter that forwards to [noSuchMethod].
class C implements B {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(
      classNames: {'A'},
      mixinNames: {'M'},
    );
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
      mixins
        mixin M @54
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
          fields
            final _foo @71
              reference: <testLibraryFragment>::@mixin::M::@field::_foo
              enclosingElement: <testLibraryFragment>::@mixin::M
              type: int?
              shouldUseTypeForInitializerInference: true
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingNsmClasses
        <testLibraryFragment>::@class::C
''');
  }

  test_class_field_isPromotable_noSuchMethodForwarder_unusedMixin() async {
    // Mixins are implicitly abstract so the presence of a mixin that inherits
    // a field into its interface, and doesn't implement it, doesn't mean that
    // a noSuchMethod forwarder created for it. So,  this does not block that
    // field from promoting.
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  A(this._foo);
}

mixin M implements A {
  dynamic noSuchMethod(Invocation invocation) {}
}
''');

    configuration.forPromotableFields(
      classNames: {'A'},
    );
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_notFinal() async {
    var library = await buildLibrary(r'''
class A {
  int? _foo;
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            _foo @17
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
  fieldNameNonPromotabilityInfo
    _foo
      conflictingFields
        <testLibraryFragment>::@class::A::@field::_foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
  fieldNameNonPromotabilityInfo
    _foo
      conflictingFields
        <testLibraryFragment>::@class::A::@field::_foo
''');
  }

  test_class_field_isPromotable_notPrivate() async {
    var library = await buildLibrary(r'''
class A {
  int? field;
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            field @17
              reference: <testLibraryFragment>::@class::A::@field::field
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_isPromotable_typeInference() async {
    // We decide that `_foo` is promotable before inferring the type of `bar`.
    var library = await buildLibrary(r'''
class A {
  final int? _foo;
  final bar = _foo != null ? _foo : 0;
  A(this._foo);
}
''');

    configuration.forPromotableFields(classNames: {'A'});
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            final promotable _foo @23
              reference: <testLibraryFragment>::@class::A::@field::_foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int?
            final bar @37
              reference: <testLibraryFragment>::@class::A::@field::bar
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: false
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_propagatedType_const_noDep() async {
    var library = await buildLibrary('''
class C {
  static const x = 0;
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static const x @25
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
              constantInitializer
                IntegerLiteral
                  literal: 0 @29
                  staticType: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_propagatedType_final_dep_inLib() async {
    addSource('$testPackageLibPath/a.dart', 'final a = 1;');
    var library = await buildLibrary('''
import "a.dart";
class C {
  final b = a / 2;
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @23
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final b @35
              reference: <testLibraryFragment>::@class::C::@field::b
              enclosingElement: <testLibraryFragment>::@class::C
              type: double
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get b @-1
              reference: <testLibraryFragment>::@class::C::@getter::b
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: double
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/a.dart
''');
  }

  test_class_field_propagatedType_final_dep_inPart() async {
    addSource('$testPackageLibPath/a.dart', 'part of lib; final a = 1;');
    var library = await buildLibrary('''
library lib;
part "a.dart";
class C {
  final b = a / 2;
}''');
    checkElementText(library, r'''
library
  name: lib
  nameOffset: 8
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  parts
    part_0
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      parts
        part_0
          uri: package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
          unit: <testLibrary>::@fragment::package:test/a.dart
      classes
        class C @34
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final b @46
              reference: <testLibraryFragment>::@class::C::@field::b
              enclosingElement: <testLibraryFragment>::@class::C
              type: double
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get b @-1
              reference: <testLibraryFragment>::@class::C::@getter::b
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: double
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
      topLevelVariables
        static final a @19
          reference: <testLibrary>::@fragment::package:test/a.dart::@topLevelVariable::a
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          type: int
          shouldUseTypeForInitializerInference: false
      accessors
        synthetic static get a @-1
          reference: <testLibrary>::@fragment::package:test/a.dart::@getter::a
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          returnType: int
----------------------------------------
library
  reference: <testLibrary>
  name: lib
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_class_field_propagatedType_final_noDep_instance() async {
    var library = await buildLibrary('''
class C {
  final x = 0;
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @18
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_propagatedType_final_noDep_static() async {
    var library = await buildLibrary('''
class C {
  static final x = 0;
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static final x @25
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_static() async {
    var library = await buildLibrary('class C { static int i; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static i @21
              reference: <testLibraryFragment>::@class::C::@field::i
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get i @-1
              reference: <testLibraryFragment>::@class::C::@getter::i
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic static set i= @-1
              reference: <testLibraryFragment>::@class::C::@setter::i
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _i @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_static_final_hasConstConstructor() async {
    var library = await buildLibrary('''
class C {
  static final f = 0;
  const C();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static final f @25
              reference: <testLibraryFragment>::@class::C::@field::f
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            const @40
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get f @-1
              reference: <testLibraryFragment>::@class::C::@getter::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_static_final_untyped() async {
    var library = await buildLibrary('class C { static final x = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static final x @23
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_static_late() async {
    var library = await buildLibrary('class C { static late int i; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            static late i @26
              reference: <testLibraryFragment>::@class::C::@field::i
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic static get i @-1
              reference: <testLibraryFragment>::@class::C::@getter::i
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic static set i= @-1
              reference: <testLibraryFragment>::@class::C::@setter::i
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _i @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_type_explicit() async {
    var library = await buildLibrary(r'''
class C {
  int a = 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            a @16
              reference: <testLibraryFragment>::@class::C::@field::a
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: true
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get a @-1
              reference: <testLibraryFragment>::@class::C::@getter::a
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set a= @-1
              reference: <testLibraryFragment>::@class::C::@setter::a
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _a @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_type_inferred_fromInitializer() async {
    var library = await buildLibrary(r'''
class C {
  var foo = 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            foo @16
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::C::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::C::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_type_inferred_fromSuper() async {
    var library = await buildLibrary(r'''
abstract class A {
  int get foo;
}

class B extends A {
  final foo = 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class A @15
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            abstract get foo @29
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
        class B @43
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          fields
            final foo @65
              reference: <testLibraryFragment>::@class::B::@field::foo
              enclosingElement: <testLibraryFragment>::@class::B
              type: int
              shouldUseTypeForInitializerInference: true
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::B::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_type_inferred_Never() async {
    var library = await buildLibrary(r'''
class C {
  var a = throw 42;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            a @16
              reference: <testLibraryFragment>::@class::C::@field::a
              enclosingElement: <testLibraryFragment>::@class::C
              type: Never
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get a @-1
              reference: <testLibraryFragment>::@class::C::@getter::a
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: Never
            synthetic set a= @-1
              reference: <testLibraryFragment>::@class::C::@setter::a
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _a @-1
                  type: Never
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_typed() async {
    var library = await buildLibrary('class C { int x = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: true
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_field_untyped() async {
    var library = await buildLibrary('class C { var x = 0; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            x @14
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_fields() async {
    var library = await buildLibrary('class C { int i; int j; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            i @14
              reference: <testLibraryFragment>::@class::C::@field::i
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
            j @21
              reference: <testLibraryFragment>::@class::C::@field::j
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get i @-1
              reference: <testLibraryFragment>::@class::C::@getter::i
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set i= @-1
              reference: <testLibraryFragment>::@class::C::@setter::i
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _i @-1
                  type: int
              returnType: void
            synthetic get j @-1
              reference: <testLibraryFragment>::@class::C::@getter::j
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set j= @-1
              reference: <testLibraryFragment>::@class::C::@setter::j
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _j @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_fields_late() async {
    var library = await buildLibrary('''
class C {
  late int foo;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            late foo @21
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::C::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::C::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_fields_late_final() async {
    var library = await buildLibrary('''
class C {
  late final int foo;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            late final foo @27
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::C::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::C::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_fields_late_final_initialized() async {
    var library = await buildLibrary('''
class C {
  late final int foo = 0;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            late final foo @27
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
              shouldUseTypeForInitializerInference: true
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::C::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_fields_late_inference_usingSuper_methodInvocation() async {
    var library = await buildLibrary('''
class A {
  int foo() => 0;
}

class B extends A {
  late var f = super.foo();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @16
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
        class B @37
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          fields
            late f @62
              reference: <testLibraryFragment>::@class::B::@field::f
              enclosingElement: <testLibraryFragment>::@class::B
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          accessors
            synthetic get f @-1
              reference: <testLibraryFragment>::@class::B::@getter::f
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: int
            synthetic set f= @-1
              reference: <testLibraryFragment>::@class::B::@setter::f
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional _f @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_fields_late_inference_usingSuper_propertyAccess() async {
    var library = await buildLibrary('''
class A {
  int get foo => 0;
}

class B extends A {
  late var f = super.foo;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @20
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
        class B @39
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          fields
            late f @64
              reference: <testLibraryFragment>::@class::B::@field::f
              enclosingElement: <testLibraryFragment>::@class::B
              type: int
              shouldUseTypeForInitializerInference: false
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          accessors
            synthetic get f @-1
              reference: <testLibraryFragment>::@class::B::@getter::f
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: int
            synthetic set f= @-1
              reference: <testLibraryFragment>::@class::B::@setter::f
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional _f @-1
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_final() async {
    var library = await buildLibrary('final class C {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        final class C @12
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_abstract() async {
    var library = await buildLibrary('abstract class C { int get x; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class C @15
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            abstract get x @27
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_external() async {
    var library = await buildLibrary('class C { external int get x; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            external get x @27
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_implicit_return_type() async {
    var library = await buildLibrary('class C { get x => null; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            get x @14
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_invokesSuperSelf_getter() async {
    var library = await buildLibrary(r'''
class A {
  int get foo {
    super.foo;
  }
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @20 invokesSuperSelf
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_invokesSuperSelf_getter_nestedInAssignment() async {
    var library = await buildLibrary(r'''
class A {
  int get foo {
    (super.foo).foo = 0;
  }
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @20 invokesSuperSelf
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_invokesSuperSelf_setter() async {
    var library = await buildLibrary(r'''
class A {
  int get foo {
    super.foo = 0;
  }
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @20
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_native() async {
    var library = await buildLibrary('''
class C {
  int get x() native;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            external get x @20
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getter_static() async {
    var library = await buildLibrary('class C { static int get x => null; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic static x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            static get x @25
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_getters() async {
    var library =
        await buildLibrary('class C { int get x => null; get y => null; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
            synthetic y @-1
              reference: <testLibraryFragment>::@class::C::@field::y
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            get x @18
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            get y @33
              reference: <testLibraryFragment>::@class::C::@getter::y
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_implicitField_getterFirst() async {
    var library = await buildLibrary('''
class C {
  int get x => 0;
  void set x(int value) {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            get x @20
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            set x= @39
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @45
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_implicitField_setterFirst() async {
    var library = await buildLibrary('''
class C {
  void set x(int value) {}
  int get x => 0;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @21
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @27
                  type: int
              returnType: void
            get x @47
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_interface() async {
    var library = await buildLibrary('interface class C {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        interface class C @16
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_interfaces() async {
    var library = await buildLibrary('''
class C implements D, E {}
class D {}
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          interfaces
            D
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class D @33
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @44
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_interfaces_extensionType() async {
    var library = await buildLibrary('''
class A {}
extension type B(int it) {}
class C {}
class D implements A, B, C {}
''');
    configuration.withConstructors = false;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
        class C @45
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
        class D @56
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          interfaces
            A
            C
      extensionTypes
        B @26
          reference: <testLibraryFragment>::@extensionType::B
          enclosingElement: <testLibraryFragment>
          representation: <testLibraryFragment>::@extensionType::B::@field::it
          primaryConstructor: <testLibraryFragment>::@extensionType::B::@constructor::new
          typeErasure: int
          fields
            final it @32
              reference: <testLibraryFragment>::@extensionType::B::@field::it
              enclosingElement: <testLibraryFragment>::@extensionType::B
              type: int
          accessors
            synthetic get it @-1
              reference: <testLibraryFragment>::@extensionType::B::@getter::it
              enclosingElement: <testLibraryFragment>::@extensionType::B
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_interfaces_Function() async {
    var library = await buildLibrary('''
class A {}
class B {}
class C implements A, Function, B {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @17
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
        class C @28
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          interfaces
            A
            B
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_interfaces_unresolved() async {
    var library = await buildLibrary(
        'class C implements X, Y, Z {} class X {} class Z {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          interfaces
            X
            Z
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class X @36
          reference: <testLibraryFragment>::@class::X
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::X::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::X
        class Z @47
          reference: <testLibraryFragment>::@class::Z
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::Z::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::Z
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_abstract() async {
    var library = await buildLibrary('abstract class C { f(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class C @15
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            abstract f @19
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_async() async {
    var library = await buildLibrary(r'''
import 'dart:async';
class C {
  Future f() async {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    dart:async
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        dart:async
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @27
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @40 async
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: Future<dynamic>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        dart:async
''');
  }

  test_class_method_asyncStar() async {
    var library = await buildLibrary(r'''
import 'dart:async';
class C {
  Stream f() async* {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    dart:async
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        dart:async
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class C @27
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @40 async*
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: Stream<dynamic>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        dart:async
''');
  }

  test_class_method_documented() async {
    var library = await buildLibrary('''
class C {
  /**
   * Docs
   */
  f() {}
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @34
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              documentationComment: /**\n   * Docs\n   */
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_external() async {
    var library = await buildLibrary('class C { external f(); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            external f @19
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_hasImplicitReturnType_false() async {
    var library = await buildLibrary('''
class C {
  int m() => 0;
}
''');
    var c = library.definingCompilationUnit.classes.single;
    var m = c.methods.single;
    expect(m.hasImplicitReturnType, isFalse);
  }

  test_class_method_hasImplicitReturnType_true() async {
    var library = await buildLibrary('''
class C {
  m() => 0;
}
''');
    var c = library.definingCompilationUnit.classes.single;
    var m = c.methods.single;
    expect(m.hasImplicitReturnType, isTrue);
  }

  test_class_method_inferred_type_nonStatic_implicit_param() async {
    var library = await buildLibrary('class C extends D { void f(value) {} }'
        ' abstract class D { void f(int value); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
          methods
            f @25
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @27
                  type: int
              returnType: void
        abstract class D @54
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
          methods
            abstract f @63
              reference: <testLibraryFragment>::@class::D::@method::f
              enclosingElement: <testLibraryFragment>::@class::D
              parameters
                requiredPositional value @69
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_inferred_type_nonStatic_implicit_return() async {
    var library = await buildLibrary('''
class C extends D {
  f() => null;
}
abstract class D {
  int f();
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
          methods
            f @22
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
        abstract class D @52
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
          methods
            abstract f @62
              reference: <testLibraryFragment>::@class::D::@method::f
              enclosingElement: <testLibraryFragment>::@class::D
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_invokesSuperSelf() async {
    var library = await buildLibrary(r'''
class A {
  void foo() {
    super.foo();
  }
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @17 invokesSuperSelf
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_namedAsSupertype() async {
    var library = await buildLibrary(r'''
class A {}
class B extends A {
  void A() {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @17
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          methods
            A @38
              reference: <testLibraryFragment>::@class::B::@method::A
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_native() async {
    var library = await buildLibrary('''
class C {
  int m() native;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            external m @16
              reference: <testLibraryFragment>::@class::C::@method::m
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_params() async {
    var library = await buildLibrary('class C { f(x, y) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @10
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional x @12
                  type: dynamic
                requiredPositional y @15
                  type: dynamic
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_static() async {
    var library = await buildLibrary('class C { static f() {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            static f @17
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_syncStar() async {
    var library = await buildLibrary(r'''
class C {
  Iterable<int> f() sync* {
    yield 42;
  }
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @26 sync*
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: Iterable<int>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_type_parameter() async {
    var library = await buildLibrary('class C { T f<T, U>(U u) => null; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @12
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              typeParameters
                covariant T @14
                  defaultType: dynamic
                covariant U @17
                  defaultType: dynamic
              parameters
                requiredPositional u @22
                  type: U
              returnType: T
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_type_parameter_in_generic_class() async {
    var library = await buildLibrary('''
class C<T, U> {
  V f<V, W>(T t, U u, W w) => null;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
            covariant U @11
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @20
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              typeParameters
                covariant V @22
                  defaultType: dynamic
                covariant W @25
                  defaultType: dynamic
              parameters
                requiredPositional t @30
                  type: T
                requiredPositional u @35
                  type: U
                requiredPositional w @40
                  type: W
              returnType: V
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_method_type_parameter_with_function_typed_parameter() async {
    var library = await buildLibrary('class C { void f<T, U>(T x(U u)) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @15
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              typeParameters
                covariant T @17
                  defaultType: dynamic
                covariant U @20
                  defaultType: dynamic
              parameters
                requiredPositional x @25
                  type: T Function(U)
                  parameters
                    requiredPositional u @29
                      type: U
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_methods() async {
    var library = await buildLibrary('class C { f() {} g() {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @10
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
            g @17
              reference: <testLibraryFragment>::@class::C::@method::g
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_mixin_class() async {
    var library = await buildLibrary('mixin class C {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        mixin class C @12
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_mixins() async {
    var library = await buildLibrary('''
class C extends D with E, F, G {}
class D {}
class E {}
class F {}
class G {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          mixins
            E
            F
            G
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @40
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @51
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
        class F @62
          reference: <testLibraryFragment>::@class::F
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::F::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::F
        class G @73
          reference: <testLibraryFragment>::@class::G
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::G::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::G
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_mixins_extensionType() async {
    var library = await buildLibrary('''
mixin A {}
extension type B(int it) {}
mixin C {}
class D extends Object with A, B, C {}
''');
    configuration.withConstructors = false;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class D @56
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            A
            C
      extensionTypes
        B @26
          reference: <testLibraryFragment>::@extensionType::B
          enclosingElement: <testLibraryFragment>
          representation: <testLibraryFragment>::@extensionType::B::@field::it
          primaryConstructor: <testLibraryFragment>::@extensionType::B::@constructor::new
          typeErasure: int
          fields
            final it @32
              reference: <testLibraryFragment>::@extensionType::B::@field::it
              enclosingElement: <testLibraryFragment>::@extensionType::B
              type: int
          accessors
            synthetic get it @-1
              reference: <testLibraryFragment>::@extensionType::B::@getter::it
              enclosingElement: <testLibraryFragment>::@extensionType::B
              returnType: int
      mixins
        mixin A @6
          reference: <testLibraryFragment>::@mixin::A
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
        mixin C @45
          reference: <testLibraryFragment>::@mixin::C
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_mixins_generic() async {
    var library = await buildLibrary('''
class Z extends A with B<int>, C<double> {}
class A {}
class B<B1> {}
class C<C1> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class Z @6
          reference: <testLibraryFragment>::@class::Z
          enclosingElement: <testLibraryFragment>
          supertype: A
          mixins
            B<int>
            C<double>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::Z::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::Z
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
        class A @50
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @61
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant B1 @63
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
        class C @76
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant C1 @78
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_mixins_genericMixin_tooManyArguments() async {
    var library = await buildLibrary('''
mixin M<T> {}
class A extends Object with M<int, String> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @20
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M<dynamic>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
      mixins
        mixin M @6
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_mixins_typeParameter() async {
    var library = await buildLibrary('''
mixin M1 {}
mixin M2 {}
class A<T> extends Object with M1, T<int>, M2 {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @30
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @32
              defaultType: dynamic
          supertype: Object
          mixins
            M1
            M2
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
      mixins
        mixin M1 @6
          reference: <testLibraryFragment>::@mixin::M1
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
        mixin M2 @18
          reference: <testLibraryFragment>::@mixin::M2
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_mixins_unresolved() async {
    var library = await buildLibrary(
        'class C extends Object with X, Y, Z {} class X {} class Z {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            X
            Z
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class X @45
          reference: <testLibraryFragment>::@class::X
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::X::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::X
        class Z @56
          reference: <testLibraryFragment>::@class::Z
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::Z::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::Z
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_circularity_via_typeAlias_recordType() async {
    var library = await buildLibrary('''
class C<T extends A> {}
typedef A = (C, int);
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: dynamic
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
      typeAliases
        notSimplyBounded A @32
          reference: <testLibraryFragment>::@typeAlias::A
          aliasedType: (C<dynamic>, int)
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_circularity_via_typedef() async {
    // C's type parameter T is not simply bounded because its bound, F, expands
    // to `dynamic F(C)`, which refers to C.
    var library = await buildLibrary('''
class C<T extends F> {}
typedef F(C value);
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: dynamic
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
      typeAliases
        functionTypeAliasBased notSimplyBounded F @32
          reference: <testLibraryFragment>::@typeAlias::F
          aliasedType: dynamic Function(C<dynamic>)
          aliasedElement: GenericFunctionTypeElement
            parameters
              requiredPositional value @36
                type: C<dynamic>
            returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_circularity_with_type_params() async {
    // C's type parameter T is simply bounded because even though it refers to
    // C, it specifies a bound.
    var library = await buildLibrary('''
class C<T extends C<dynamic>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: C<dynamic>
              defaultType: C<dynamic>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_complex_by_cycle_class() async {
    var library = await buildLibrary('''
class C<T extends D> {}
class D<T extends C> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: D<dynamic>
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        notSimplyBounded class D @30
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @32
              bound: C<dynamic>
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_complex_by_cycle_typedef_functionType() async {
    var library = await buildLibrary('''
typedef C<T extends D> = void Function();
typedef D<T extends C> = void Function();
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      typeAliases
        notSimplyBounded C @8
          reference: <testLibraryFragment>::@typeAlias::C
          typeParameters
            unrelated T @10
              bound: dynamic
              defaultType: dynamic
          aliasedType: void Function()
          aliasedElement: GenericFunctionTypeElement
            returnType: void
        notSimplyBounded D @50
          reference: <testLibraryFragment>::@typeAlias::D
          typeParameters
            unrelated T @52
              bound: dynamic
              defaultType: dynamic
          aliasedType: void Function()
          aliasedElement: GenericFunctionTypeElement
            returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_complex_by_cycle_typedef_interfaceType() async {
    var library = await buildLibrary('''
typedef C<T extends D> = List<T>;
typedef D<T extends C> = List<T>;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      typeAliases
        notSimplyBounded C @8
          reference: <testLibraryFragment>::@typeAlias::C
          typeParameters
            covariant T @10
              bound: dynamic
              defaultType: dynamic
          aliasedType: List<T>
        notSimplyBounded D @42
          reference: <testLibraryFragment>::@typeAlias::D
          typeParameters
            covariant T @44
              bound: dynamic
              defaultType: dynamic
          aliasedType: List<T>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_complex_by_reference_to_cycle() async {
    var library = await buildLibrary('''
class C<T extends D> {}
class D<T extends D> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: D<dynamic>
              defaultType: D<dynamic>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        notSimplyBounded class D @30
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @32
              bound: D<dynamic>
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_complex_by_use_of_parameter() async {
    var library = await buildLibrary('''
class C<T extends D<T>> {}
class D<T> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: D<T>
              defaultType: D<dynamic>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class D @33
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @35
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_dependency_with_type_params() async {
    // C's type parameter T is simply bounded because even though it refers to
    // non-simply-bounded type D, it specifies a bound.
    var library = await buildLibrary('''
class C<T extends D<dynamic>> {}
class D<T extends D<T>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: D<dynamic>
              defaultType: D<dynamic>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        notSimplyBounded class D @39
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @41
              bound: D<T>
              defaultType: D<dynamic>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_function_typed_bound_complex_via_parameter_type() async {
    var library = await buildLibrary('''
class C<T extends void Function(T)> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: void Function(T)
              defaultType: void Function(Never)
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_function_typed_bound_complex_via_return_type() async {
    var library = await buildLibrary('''
class C<T extends T Function()> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: T Function()
              defaultType: dynamic Function()
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_function_typed_bound_simple() async {
    var library = await buildLibrary('''
class C<T extends void Function()> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: void Function()
              defaultType: void Function()
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_refers_to_circular_typedef() async {
    // C's type parameter T has a bound of F, which is a circular typedef.  This
    // is illegal in Dart, but we need to make sure it doesn't lead to a crash
    // or infinite loop.
    var library = await buildLibrary('''
class C<T extends F> {}
typedef F(G value);
typedef G(F value);
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: dynamic
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
      typeAliases
        functionTypeAliasBased notSimplyBounded F @32
          reference: <testLibraryFragment>::@typeAlias::F
          aliasedType: dynamic Function(dynamic)
          aliasedElement: GenericFunctionTypeElement
            parameters
              requiredPositional value @36
                type: dynamic
            returnType: dynamic
        functionTypeAliasBased notSimplyBounded G @52
          reference: <testLibraryFragment>::@typeAlias::G
          aliasedType: dynamic Function(dynamic)
          aliasedElement: GenericFunctionTypeElement
            parameters
              requiredPositional value @56
                type: dynamic
            returnType: dynamic
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_self() async {
    var library = await buildLibrary('''
class C<T extends C> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: C<dynamic>
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_simple_because_non_generic() async {
    // If no type parameters are specified, then the class is simply bounded, so
    // there is no reason to assign it a slot.
    var library = await buildLibrary('''
class C {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_simple_by_lack_of_cycles() async {
    var library = await buildLibrary('''
class C<T extends D> {}
class D<T> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: D<dynamic>
              defaultType: D<dynamic>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class D @30
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @32
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_notSimplyBounded_simple_by_syntax() async {
    // If no bounds are specified, then the class is simply bounded by syntax
    // alone, so there is no reason to assign it a slot.
    var library = await buildLibrary('''
class C<T> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_operator() async {
    var library =
        await buildLibrary('class C { C operator+(C other) => null; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            + @20
              reference: <testLibraryFragment>::@class::C::@method::+
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional other @24
                  type: C
              returnType: C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_operator_equal() async {
    var library = await buildLibrary('''
class C {
  bool operator==(Object other) => false;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            == @25
              reference: <testLibraryFragment>::@class::C::@method::==
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional other @35
                  type: Object
              returnType: bool
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_operator_external() async {
    var library =
        await buildLibrary('class C { external C operator+(C other); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            external + @29
              reference: <testLibraryFragment>::@class::C::@method::+
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional other @33
                  type: C
              returnType: C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_operator_greater_equal() async {
    var library = await buildLibrary('''
class C {
  bool operator>=(C other) => false;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            >= @25
              reference: <testLibraryFragment>::@class::C::@method::>=
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional other @30
                  type: C
              returnType: bool
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_operator_index() async {
    var library =
        await buildLibrary('class C { bool operator[](int i) => null; }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            [] @23
              reference: <testLibraryFragment>::@class::C::@method::[]
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional i @30
                  type: int
              returnType: bool
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_operator_index_set() async {
    var library = await buildLibrary('''
class C {
  void operator[]=(int i, bool v) {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            []= @25
              reference: <testLibraryFragment>::@class::C::@method::[]=
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional i @33
                  type: int
                requiredPositional v @41
                  type: bool
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_operator_less_equal() async {
    var library = await buildLibrary('''
class C {
  bool operator<=(C other) => false;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            <= @25
              reference: <testLibraryFragment>::@class::C::@method::<=
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional other @30
                  type: C
              returnType: bool
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_ref_nullability_none() async {
    var library = await buildLibrary('''
class C {}
C c;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
      topLevelVariables
        static c @13
          reference: <testLibraryFragment>::@topLevelVariable::c
          enclosingElement: <testLibraryFragment>
          type: C
      accessors
        synthetic static get c @-1
          reference: <testLibraryFragment>::@getter::c
          enclosingElement: <testLibraryFragment>
          returnType: C
        synthetic static set c= @-1
          reference: <testLibraryFragment>::@setter::c
          enclosingElement: <testLibraryFragment>
          parameters
            requiredPositional _c @-1
              type: C
          returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_ref_nullability_question() async {
    var library = await buildLibrary('''
class C {}
C? c;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
      topLevelVariables
        static c @14
          reference: <testLibraryFragment>::@topLevelVariable::c
          enclosingElement: <testLibraryFragment>
          type: C?
      accessors
        synthetic static get c @-1
          reference: <testLibraryFragment>::@getter::c
          enclosingElement: <testLibraryFragment>
          returnType: C?
        synthetic static set c= @-1
          reference: <testLibraryFragment>::@setter::c
          enclosingElement: <testLibraryFragment>
          parameters
            requiredPositional _c @-1
              type: C?
          returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed() async {
    var library = await buildLibrary('sealed class C {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract sealed class C @13
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed_induced_base_extends_base() async {
    var library = await buildLibrary('''
base class A {}
sealed class B extends A {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        base class A @11
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        abstract sealed base class B @29
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed_induced_base_implements_base() async {
    var library = await buildLibrary('''
base class A {}
sealed class B implements A {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        base class A @11
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        abstract sealed base class B @29
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          interfaces
            A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed_induced_base_implements_final() async {
    var library = await buildLibrary('''
final class A {}
sealed class B implements A {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        final class A @12
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        abstract sealed base class B @30
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          interfaces
            A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed_induced_final_extends_final() async {
    var library = await buildLibrary('''
final class A {}
sealed class B extends A {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        final class A @12
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        abstract sealed final class B @30
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed_induced_final_with_base_mixin() async {
    var library = await buildLibrary('''
base mixin A {}
interface class B {}
sealed class C extends B with A {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        interface class B @32
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
        abstract sealed final class C @50
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: B
          mixins
            A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::B::@constructor::new
      mixins
        base mixin A @11
          reference: <testLibraryFragment>::@mixin::A
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed_induced_interface_extends_interface() async {
    var library = await buildLibrary('''
interface class A {}
sealed class B extends A {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        interface class A @16
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        abstract sealed interface class B @34
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_sealed_induced_none_implements_interface() async {
    var library = await buildLibrary('''
interface class A {}
sealed class B implements A {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        interface class A @16
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        abstract sealed class B @34
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          interfaces
            A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_abstract() async {
    var library =
        await buildLibrary('abstract class C { void set x(int value); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class C @15
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            abstract set x= @28
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @34
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_covariant() async {
    var library =
        await buildLibrary('class C { void set x(covariant int value); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            abstract set x= @19
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional covariant value @35
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_external() async {
    var library =
        await buildLibrary('class C { external void set x(int value); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            external set x= @28
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @34
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_implicit_param_type() async {
    var library = await buildLibrary('class C { void set x(value) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @19
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @21
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_implicit_return_type() async {
    var library = await buildLibrary('class C { set x(int value) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @14
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @20
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_inferred_type_conflictingInheritance() async {
    var library = await buildLibrary('''
class A {
  int t;
}
class B extends A {
  double t;
}
class C extends A implements B {
}
class D extends C {
  void set t(p) {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            t @16
              reference: <testLibraryFragment>::@class::A::@field::t
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get t @-1
              reference: <testLibraryFragment>::@class::A::@getter::t
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
            synthetic set t= @-1
              reference: <testLibraryFragment>::@class::A::@setter::t
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _t @-1
                  type: int
              returnType: void
        class B @27
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
          fields
            t @50
              reference: <testLibraryFragment>::@class::B::@field::t
              enclosingElement: <testLibraryFragment>::@class::B
              type: double
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          accessors
            synthetic get t @-1
              reference: <testLibraryFragment>::@class::B::@getter::t
              enclosingElement: <testLibraryFragment>::@class::B
              returnType: double
            synthetic set t= @-1
              reference: <testLibraryFragment>::@class::B::@setter::t
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional _t @-1
                  type: double
              returnType: void
        class C @61
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: A
          interfaces
            B
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
        class D @96
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          supertype: C
          fields
            synthetic t @-1
              reference: <testLibraryFragment>::@class::D::@field::t
              enclosingElement: <testLibraryFragment>::@class::D
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
              superConstructor: <testLibraryFragment>::@class::C::@constructor::new
          accessors
            set t= @121
              reference: <testLibraryFragment>::@class::D::@setter::t
              enclosingElement: <testLibraryFragment>::@class::D
              parameters
                requiredPositional p @123
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_inferred_type_nonStatic_implicit_param() async {
    var library =
        await buildLibrary('class C extends D { void set f(value) {} }'
            ' abstract class D { void set f(int value); }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          fields
            synthetic f @-1
              reference: <testLibraryFragment>::@class::C::@field::f
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
          accessors
            set f= @29
              reference: <testLibraryFragment>::@class::C::@setter::f
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @31
                  type: int
              returnType: void
        abstract class D @58
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          fields
            synthetic f @-1
              reference: <testLibraryFragment>::@class::D::@field::f
              enclosingElement: <testLibraryFragment>::@class::D
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
          accessors
            abstract set f= @71
              reference: <testLibraryFragment>::@class::D::@setter::f
              enclosingElement: <testLibraryFragment>::@class::D
              parameters
                requiredPositional value @77
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_inferred_type_static_implicit_return() async {
    var library = await buildLibrary('''
class C {
  static set f(int value) {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic static f @-1
              reference: <testLibraryFragment>::@class::C::@field::f
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            static set f= @23
              reference: <testLibraryFragment>::@class::C::@setter::f
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @29
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_invalid_named_parameter() async {
    var library = await buildLibrary('class C { void set x({a}) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @19
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                optionalNamed default a @22
                  reference: <testLibraryFragment>::@class::C::@setter::x::@parameter::a
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_invalid_no_parameter() async {
    var library = await buildLibrary('class C { void set x() {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @19
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_invalid_optional_parameter() async {
    var library = await buildLibrary('class C { void set x([a]) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @19
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                optionalPositional default a @22
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_invalid_too_many_parameters() async {
    var library = await buildLibrary('class C { void set x(a, b) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @19
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional a @21
                  type: dynamic
                requiredPositional b @24
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_invokesSuperSelf_getter() async {
    var library = await buildLibrary(r'''
class A {
  set foo(int _) {
    super.foo;
  }
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            set foo= @16
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @24
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_invokesSuperSelf_setter() async {
    var library = await buildLibrary(r'''
class A {
  set foo(int _) {
    super.foo = 0;
  }
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            set foo= @16 invokesSuperSelf
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @24
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_native() async {
    var library = await buildLibrary('''
class C {
  void set x(int value) native;
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            external set x= @21
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @27
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setter_static() async {
    var library =
        await buildLibrary('class C { static void set x(int value) {} }');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic static x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            static set x= @26
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @32
                  type: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_setters() async {
    var library = await buildLibrary('''
class C {
  void set x(int value) {}
  set y(value) {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
            synthetic y @-1
              reference: <testLibraryFragment>::@class::C::@field::y
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @21
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @27
                  type: int
              returnType: void
            set y= @43
              reference: <testLibraryFragment>::@class::C::@setter::y
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional value @45
                  type: dynamic
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype() async {
    var library = await buildLibrary('''
class A {}
class B extends A {}
''');
    configuration.withConstructors = false;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
        class B @17
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype_dynamic() async {
    var library = await buildLibrary('''
class A extends dynamic {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype_extensionType() async {
    var library = await buildLibrary('''
extension type A(int it) {}
class B extends A {}
''');
    configuration.withConstructors = false;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @34
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
      extensionTypes
        A @15
          reference: <testLibraryFragment>::@extensionType::A
          enclosingElement: <testLibraryFragment>
          representation: <testLibraryFragment>::@extensionType::A::@field::it
          primaryConstructor: <testLibraryFragment>::@extensionType::A::@constructor::new
          typeErasure: int
          fields
            final it @21
              reference: <testLibraryFragment>::@extensionType::A::@field::it
              enclosingElement: <testLibraryFragment>::@extensionType::A
              type: int
          accessors
            synthetic get it @-1
              reference: <testLibraryFragment>::@extensionType::A::@getter::it
              enclosingElement: <testLibraryFragment>::@extensionType::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype_genericClass() async {
    var library = await buildLibrary('''
class C extends D<int, double> {}
class D<T1, T2> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D<int, double>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::D::@constructor::new
                substitution: {T1: int, T2: double}
        class D @40
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T1 @42
              defaultType: dynamic
            covariant T2 @46
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype_genericClass_tooManyArguments() async {
    var library = await buildLibrary('''
class A<T> {}
class B extends A<int, String> {}
''');
    configuration.withConstructors = false;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
        class B @20
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A<dynamic>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype_typeArguments_self() async {
    var library = await buildLibrary('''
class A<T> {}
class B extends A<B> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @20
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          supertype: A<B>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::A::@constructor::new
                substitution: {T: B}
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype_typeParameter() async {
    var library = await buildLibrary('''
class A<T> extends T<int> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_supertype_unresolved() async {
    var library = await buildLibrary('class C extends D {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters() async {
    var library = await buildLibrary('class C<T, U> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
            covariant U @11
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_bound() async {
    var library = await buildLibrary('''
class C<T extends Object, U extends D> {}
class D {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: Object
              defaultType: Object
            covariant U @26
              bound: D
              defaultType: D
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class D @48
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_cycle_1of1() async {
    var library = await buildLibrary('class C<T extends T> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: dynamic
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_cycle_2of3() async {
    var library = await buildLibrary(r'''
class C<T extends V, U, V extends T> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: dynamic
              defaultType: dynamic
            covariant U @21
              defaultType: dynamic
            covariant V @24
              bound: dynamic
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_cycle_genericFunctionType() async {
    var library = await buildLibrary(r'''
class A<T extends void Function(A)> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: void Function(A<dynamic>)
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_cycle_genericFunctionType2() async {
    var library = await buildLibrary(r'''
class C<T extends void Function<U extends C>()> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: void Function<U extends C<dynamic>>()
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_functionTypeAlias_contravariant() async {
    var library = await buildLibrary(r'''
typedef F<X> = void Function(X);

class A<X extends F<X>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @40
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @42
              bound: void Function(X)
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    X
              defaultType: void Function(Never)
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    Never
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
      typeAliases
        F @8
          reference: <testLibraryFragment>::@typeAlias::F
          typeParameters
            contravariant X @10
              defaultType: dynamic
          aliasedType: void Function(X)
          aliasedElement: GenericFunctionTypeElement
            parameters
              requiredPositional @-1
                type: X
            returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_functionTypeAlias_covariant() async {
    var library = await buildLibrary(r'''
typedef F<X> = X Function();

class A<X extends F<X>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @36
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @38
              bound: X Function()
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    X
              defaultType: dynamic Function()
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
      typeAliases
        F @8
          reference: <testLibraryFragment>::@typeAlias::F
          typeParameters
            covariant X @10
              defaultType: dynamic
          aliasedType: X Function()
          aliasedElement: GenericFunctionTypeElement
            returnType: X
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_functionTypeAlias_invariant() async {
    var library = await buildLibrary(r'''
typedef F<X> = X Function(X);

class A<X extends F<X>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @37
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @39
              bound: X Function(X)
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    X
              defaultType: dynamic Function(dynamic)
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
      typeAliases
        F @8
          reference: <testLibraryFragment>::@typeAlias::F
          typeParameters
            invariant X @10
              defaultType: dynamic
          aliasedType: X Function(X)
          aliasedElement: GenericFunctionTypeElement
            parameters
              requiredPositional @-1
                type: X
            returnType: X
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_functionTypeAlias_invariant_legacy() async {
    var library = await buildLibrary(r'''
typedef F<X> = X Function(X);

class A<X extends F<X>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @37
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @39
              bound: X Function(X)
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    X
              defaultType: dynamic Function(dynamic)
                alias: <testLibraryFragment>::@typeAlias::F
                  typeArguments
                    dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
      typeAliases
        F @8
          reference: <testLibraryFragment>::@typeAlias::F
          typeParameters
            invariant X @10
              defaultType: dynamic
          aliasedType: X Function(X)
          aliasedElement: GenericFunctionTypeElement
            parameters
              requiredPositional @-1
                type: X
            returnType: X
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_genericFunctionType_both() async {
    var library = await buildLibrary(r'''
class A<X extends X Function(X)> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @8
              bound: X Function(X)
              defaultType: dynamic Function(Never)
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_genericFunctionType_contravariant() async {
    var library = await buildLibrary(r'''
class A<X extends void Function(X)> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @8
              bound: void Function(X)
              defaultType: void Function(Never)
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_genericFunctionType_covariant() async {
    var library = await buildLibrary(r'''
class A<X extends X Function()> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @8
              bound: X Function()
              defaultType: dynamic Function()
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_genericFunctionType_covariant_legacy() async {
    var library = await buildLibrary(r'''
class A<X extends X Function()> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @8
              bound: X Function()
              defaultType: dynamic Function()
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_typeAlias_interface_contravariant() async {
    var library = await buildLibrary(r'''
typedef A<X> = List<void Function(X)>;

class B<X extends A<X>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class B @46
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @48
              bound: List<void Function(X)>
                alias: <testLibraryFragment>::@typeAlias::A
                  typeArguments
                    X
              defaultType: List<void Function(Never)>
                alias: <testLibraryFragment>::@typeAlias::A
                  typeArguments
                    Never
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
      typeAliases
        A @8
          reference: <testLibraryFragment>::@typeAlias::A
          typeParameters
            contravariant X @10
              defaultType: dynamic
          aliasedType: List<void Function(X)>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_defaultType_typeAlias_interface_covariant() async {
    var library = await buildLibrary(r'''
typedef A<X> = Map<X, int>;

class B<X extends A<X>> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class B @35
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant X @37
              bound: Map<X, int>
                alias: <testLibraryFragment>::@typeAlias::A
                  typeArguments
                    X
              defaultType: Map<dynamic, int>
                alias: <testLibraryFragment>::@typeAlias::A
                  typeArguments
                    dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
      typeAliases
        A @8
          reference: <testLibraryFragment>::@typeAlias::A
          typeParameters
            covariant X @10
              defaultType: dynamic
          aliasedType: Map<X, int>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_f_bound_complex() async {
    var library = await buildLibrary('class C<T extends List<U>, U> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: List<U>
              defaultType: List<dynamic>
            covariant U @27
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_f_bound_simple() async {
    var library = await buildLibrary('class C<T extends U, U> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: U
              defaultType: dynamic
            covariant U @21
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_variance_contravariant() async {
    var library = await buildLibrary('class C<in T> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            contravariant T @11
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_variance_covariant() async {
    var library = await buildLibrary('class C<out T> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @12
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_variance_invariant() async {
    var library = await buildLibrary('class C<inout T> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            invariant T @14
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_class_typeParameters_variance_multiple() async {
    var library = await buildLibrary('class C<inout T, in U, out V> {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            invariant T @14
              defaultType: dynamic
            contravariant U @20
              defaultType: dynamic
            covariant V @27
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias() async {
    var library = await buildLibrary('''
class C = D with E, F, G;
class D {}
class E {}
class F {}
class G {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          mixins
            E
            F
            G
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @32
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @43
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
        class F @54
          reference: <testLibraryFragment>::@class::F
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::F::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::F
        class G @65
          reference: <testLibraryFragment>::@class::G
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::G::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::G
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_abstract() async {
    var library = await buildLibrary('''
abstract class C = D with E;
class D {}
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class alias C @15
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @35
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @46
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_base() async {
    var library = await buildLibrary('''
base class C = Object with M;
mixin M {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        base class alias C @11
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: dart:core::<fragment>::@class::Object::@constructor::new
      mixins
        mixin M @36
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_constructors_default() async {
    var library = await buildLibrary('''
class A {}
mixin class M {}
class X = A with M;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        mixin class M @23
          reference: <testLibraryFragment>::@class::M
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::M::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::M
        class alias X @34
          reference: <testLibraryFragment>::@class::X
          enclosingElement: <testLibraryFragment>
          supertype: A
          mixins
            M
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::X::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::X
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::A::@constructor::new
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_constructors_dependencies() async {
    var library = await buildLibrary('''
class A {
  A(int i);
}
mixin class M1 {}
mixin class M2 {}

class C2 = C1 with M2;
class C1 = A with M1;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            @12
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional i @18
                  type: int
        mixin class M1 @36
          reference: <testLibraryFragment>::@class::M1
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::M1::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::M1
        mixin class M2 @54
          reference: <testLibraryFragment>::@class::M2
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::M2::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::M2
        class alias C2 @67
          reference: <testLibraryFragment>::@class::C2
          enclosingElement: <testLibraryFragment>
          supertype: C1
          mixins
            M2
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C2::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C2
              parameters
                requiredPositional i @-1
                  type: int
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: i @-1
                        staticElement: <testLibraryFragment>::@class::C2::@constructor::new::@parameter::i
                        staticType: int
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::C1::@constructor::new
              superConstructor: <testLibraryFragment>::@class::C1::@constructor::new
        class alias C1 @90
          reference: <testLibraryFragment>::@class::C1
          enclosingElement: <testLibraryFragment>
          supertype: A
          mixins
            M1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C1::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C1
              parameters
                requiredPositional i @-1
                  type: int
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: i @-1
                        staticElement: <testLibraryFragment>::@class::C1::@constructor::new::@parameter::i
                        staticType: int
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::A::@constructor::new
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_constructors_optionalParameters() async {
    var library = await buildLibrary('''
class A {
  A.c1(int a);
  A.c2(int a, [int? b, int c = 0]);
  A.c3(int a, {int? b, int c = 0});
}

mixin M {}

class C = A with M;
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            c1 @14
              reference: <testLibraryFragment>::@class::A::@constructor::c1
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 13
              nameEnd: 16
              parameters
                requiredPositional a @21
                  type: int
            c2 @29
              reference: <testLibraryFragment>::@class::A::@constructor::c2
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 28
              nameEnd: 31
              parameters
                requiredPositional a @36
                  type: int
                optionalPositional default b @45
                  type: int?
                optionalPositional default c @52
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 0 @56
                      staticType: int
            c3 @65
              reference: <testLibraryFragment>::@class::A::@constructor::c3
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 64
              nameEnd: 67
              parameters
                requiredPositional a @72
                  type: int
                optionalNamed default b @81
                  reference: <testLibraryFragment>::@class::A::@constructor::c3::@parameter::b
                  type: int?
                optionalNamed default c @88
                  reference: <testLibraryFragment>::@class::A::@constructor::c3::@parameter::c
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 0 @92
                      staticType: int
        class alias C @118
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: A
          mixins
            M
          constructors
            synthetic c1 @-1
              reference: <testLibraryFragment>::@class::C::@constructor::c1
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional a @-1
                  type: int
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: c1 @-1
                    staticElement: <testLibraryFragment>::@class::A::@constructor::c1
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: a @-1
                        staticElement: <testLibraryFragment>::@class::C::@constructor::c1::@parameter::a
                        staticType: int
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::A::@constructor::c1
              superConstructor: <testLibraryFragment>::@class::A::@constructor::c1
            synthetic c2 @-1
              reference: <testLibraryFragment>::@class::C::@constructor::c2
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional a @-1
                  type: int
                optionalPositional default b @-1
                  type: int?
                optionalPositional default c @-1
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 0 @56
                      staticType: int
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: c2 @-1
                    staticElement: <testLibraryFragment>::@class::A::@constructor::c2
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: a @-1
                        staticElement: <testLibraryFragment>::@class::C::@constructor::c2::@parameter::a
                        staticType: int
                      SimpleIdentifier
                        token: b @-1
                        staticElement: <testLibraryFragment>::@class::C::@constructor::c2::@parameter::b
                        staticType: int?
                      SimpleIdentifier
                        token: c @-1
                        staticElement: <testLibraryFragment>::@class::C::@constructor::c2::@parameter::c
                        staticType: int
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::A::@constructor::c2
              superConstructor: <testLibraryFragment>::@class::A::@constructor::c2
            synthetic c3 @-1
              reference: <testLibraryFragment>::@class::C::@constructor::c3
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional a @-1
                  type: int
                optionalNamed default b @-1
                  reference: <testLibraryFragment>::@class::C::@constructor::c3::@parameter::b
                  type: int?
                optionalNamed default c @-1
                  reference: <testLibraryFragment>::@class::C::@constructor::c3::@parameter::c
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 0 @92
                      staticType: int
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: c3 @-1
                    staticElement: <testLibraryFragment>::@class::A::@constructor::c3
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: a @-1
                        staticElement: <testLibraryFragment>::@class::C::@constructor::c3::@parameter::a
                        staticType: int
                      SimpleIdentifier
                        token: b @-1
                        staticElement: <testLibraryFragment>::@class::C::@constructor::c3::@parameter::b
                        staticType: int?
                      SimpleIdentifier
                        token: c @-1
                        staticElement: <testLibraryFragment>::@class::C::@constructor::c3::@parameter::c
                        staticType: int
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::A::@constructor::c3
              superConstructor: <testLibraryFragment>::@class::A::@constructor::c3
      mixins
        mixin M @106
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_constructors_requiredParameters() async {
    var library = await buildLibrary('''
class A<T extends num> {
  A(T x, T y);
}

mixin M {}

class B<E extends num> = A<E> with M;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: num
              defaultType: num
          constructors
            @27
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional x @31
                  type: T
                requiredPositional y @36
                  type: T
        class alias B @61
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant E @63
              bound: num
              defaultType: num
          supertype: A<E>
          mixins
            M
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional x @-1
                  type: E
                requiredPositional y @-1
                  type: E
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: x @-1
                        staticElement: <testLibraryFragment>::@class::B::@constructor::new::@parameter::x
                        staticType: E
                      SimpleIdentifier
                        token: y @-1
                        staticElement: <testLibraryFragment>::@class::B::@constructor::new::@parameter::y
                        staticType: E
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::A::@constructor::new
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::A::@constructor::new
                substitution: {T: E}
      mixins
        mixin M @49
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_documented() async {
    var library = await buildLibrary('''
/**
 * Docs
 */
class C = D with E;

class D {}
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias C @22
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * Docs\n */
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @43
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @54
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_documented_tripleSlash() async {
    var library = await buildLibrary('''
/// aaa
/// b
/// cc
class C = D with E;

class D {}
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias C @27
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /// aaa\n/// b\n/// cc
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @48
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @59
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_documented_withLeadingNonDocumentation() async {
    var library = await buildLibrary('''
// Extra comment so doc comment offset != 0
/**
 * Docs
 */
class C = D with E;

class D {}
class E {}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias C @66
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          documentationComment: /**\n * Docs\n */
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @87
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @98
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_final() async {
    var library = await buildLibrary('''
final class C = Object with M;
mixin M {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        final class alias C @12
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: dart:core::<fragment>::@class::Object::@constructor::new
      mixins
        mixin M @37
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_generic() async {
    var library = await buildLibrary('''
class Z = A with B<int>, C<double>;
class A {}
class B<B1> {}
class C<C1> {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias Z @6
          reference: <testLibraryFragment>::@class::Z
          enclosingElement: <testLibraryFragment>
          supertype: A
          mixins
            B<int>
            C<double>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::Z::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::Z
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::A::@constructor::new
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
        class A @42
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @53
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant B1 @55
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
        class C @68
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant C1 @70
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_interface() async {
    var library = await buildLibrary('''
interface class C = Object with M;
mixin M {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        interface class alias C @16
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: dart:core::<fragment>::@class::Object::@constructor::new
      mixins
        mixin M @41
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_invalid_extendsEnum() async {
    newFile('$testPackageLibPath/a.dart', r'''
enum E { v }
mixin M {}
''');

    var library = await buildLibrary('''
import 'a.dart';
class A = E with M;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class alias A @23
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: dart:core::<fragment>::@class::Object::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/a.dart
''');
  }

  test_classAlias_invalid_extendsMixin() async {
    var library = await buildLibrary('''
mixin M1 {}
mixin M2 {}
class A = M1 with M2;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias A @30
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M2
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: dart:core::<fragment>::@class::Object::@constructor::new
      mixins
        mixin M1 @6
          reference: <testLibraryFragment>::@mixin::M1
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
        mixin M2 @18
          reference: <testLibraryFragment>::@mixin::M2
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_mixin_class() async {
    var library = await buildLibrary('''
mixin class C = Object with M;
mixin M {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        mixin class alias C @12
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: dart:core::<fragment>::@class::Object::@constructor::new
      mixins
        mixin M @37
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_notSimplyBounded_self() async {
    var library = await buildLibrary('''
class C<T extends C> = D with E;
class D {}
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class alias C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              bound: C<dynamic>
              defaultType: dynamic
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @39
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @50
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_notSimplyBounded_simple_no_type_parameter_bound() async {
    // If no bounds are specified, then the class is simply bounded by syntax
    // alone, so there is no reason to assign it a slot.
    var library = await buildLibrary('''
class C<T> = D with E;
class D {}
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @29
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @40
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_notSimplyBounded_simple_non_generic() async {
    // If no type parameters are specified, then the class is simply bounded, so
    // there is no reason to assign it a slot.
    var library = await buildLibrary('''
class C = D with E;
class D {}
class E {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @26
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @37
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_sealed() async {
    var library = await buildLibrary('''
sealed class C = Object with M;
mixin M {}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract sealed class alias C @13
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: Object
          mixins
            M
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: dart:core::<fragment>::@class::Object::@constructor::new
      mixins
        mixin M @38
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_with_const_constructors() async {
    addSource('$testPackageLibPath/a.dart', r'''
class Base {
  const Base._priv();
  const Base();
  const Base.named();
}
''');
    var library = await buildLibrary('''
import "a.dart";
class M {}
class MixinApp = Base with M;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class M @23
          reference: <testLibraryFragment>::@class::M
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::M::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::M
        class alias MixinApp @34
          reference: <testLibraryFragment>::@class::MixinApp
          enclosingElement: <testLibraryFragment>
          supertype: Base
          mixins
            M
          constructors
            synthetic const @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::new
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::new
            synthetic const named @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: named @-1
                    staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::named
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::named
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::named
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/a.dart
''');
  }

  test_classAlias_with_forwarding_constructors() async {
    addSource('$testPackageLibPath/a.dart', r'''
class Base {
  bool x = true;
  Base._priv();
  Base();
  Base.noArgs();
  Base.requiredArg(x);
  Base.positionalArg([bool x = true]);
  Base.positionalArg2([this.x = true]);
  Base.namedArg({int x = 42});
  Base.namedArg2({this.x = true});
  factory Base.fact() => Base();
  factory Base.fact2() = Base.noArgs;
}
''');
    var library = await buildLibrary('''
import "a.dart";
class M {}
class MixinApp = Base with M;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class M @23
          reference: <testLibraryFragment>::@class::M
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::M::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::M
        class alias MixinApp @34
          reference: <testLibraryFragment>::@class::MixinApp
          enclosingElement: <testLibraryFragment>
          supertype: Base
          mixins
            M
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::new
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::new
            synthetic noArgs @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::noArgs
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: noArgs @-1
                    staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::noArgs
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::noArgs
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::noArgs
            synthetic requiredArg @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::requiredArg
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              parameters
                requiredPositional x @-1
                  type: dynamic
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: requiredArg @-1
                    staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::requiredArg
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: x @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::requiredArg::@parameter::x
                        staticType: dynamic
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::requiredArg
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::requiredArg
            synthetic positionalArg @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::positionalArg
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              parameters
                optionalPositional default x @-1
                  type: bool
                  constantInitializer
                    BooleanLiteral
                      literal: true @127
                      staticType: bool
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: positionalArg @-1
                    staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::positionalArg
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: x @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::positionalArg::@parameter::x
                        staticType: bool
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::positionalArg
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::positionalArg
            synthetic positionalArg2 @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::positionalArg2
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              parameters
                optionalPositional default final x @-1
                  type: bool
                  constantInitializer
                    BooleanLiteral
                      literal: true @167
                      staticType: bool
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: positionalArg2 @-1
                    staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::positionalArg2
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: x @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::positionalArg2::@parameter::x
                        staticType: bool
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::positionalArg2
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::positionalArg2
            synthetic namedArg @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::namedArg
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              parameters
                optionalNamed default x @-1
                  reference: <testLibraryFragment>::@class::MixinApp::@constructor::namedArg::@parameter::x
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 42 @200
                      staticType: int
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: namedArg @-1
                    staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::namedArg
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: x @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::namedArg::@parameter::x
                        staticType: int
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::namedArg
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::namedArg
            synthetic namedArg2 @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::namedArg2
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              parameters
                optionalNamed default final x @-1
                  reference: <testLibraryFragment>::@class::MixinApp::@constructor::namedArg2::@parameter::x
                  type: bool
                  constantInitializer
                    BooleanLiteral
                      literal: true @233
                      staticType: bool
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: namedArg2 @-1
                    staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::namedArg2
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: x @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::namedArg2::@parameter::x
                        staticType: bool
                    rightParenthesis: ) @0
                  staticElement: package:test/a.dart::<fragment>::@class::Base::@constructor::namedArg2
              superConstructor: package:test/a.dart::<fragment>::@class::Base::@constructor::namedArg2
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/a.dart
''');
  }

  test_classAlias_with_forwarding_constructors_type_substitution() async {
    var library = await buildLibrary('''
class Base<T> {
  Base.ctor(T t, List<T> l);
}
class M {}
class MixinApp = Base with M;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class Base @6
          reference: <testLibraryFragment>::@class::Base
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @11
              defaultType: dynamic
          constructors
            ctor @23
              reference: <testLibraryFragment>::@class::Base::@constructor::ctor
              enclosingElement: <testLibraryFragment>::@class::Base
              periodOffset: 22
              nameEnd: 27
              parameters
                requiredPositional t @30
                  type: T
                requiredPositional l @41
                  type: List<T>
        class M @53
          reference: <testLibraryFragment>::@class::M
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::M::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::M
        class alias MixinApp @64
          reference: <testLibraryFragment>::@class::MixinApp
          enclosingElement: <testLibraryFragment>
          supertype: Base<dynamic>
          mixins
            M
          constructors
            synthetic ctor @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::ctor
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              parameters
                requiredPositional t @-1
                  type: dynamic
                requiredPositional l @-1
                  type: List<dynamic>
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: ctor @-1
                    staticElement: <testLibraryFragment>::@class::Base::@constructor::ctor
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: t @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::ctor::@parameter::t
                        staticType: dynamic
                      SimpleIdentifier
                        token: l @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::ctor::@parameter::l
                        staticType: List<dynamic>
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::Base::@constructor::ctor
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::Base::@constructor::ctor
                substitution: {T: dynamic}
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_with_forwarding_constructors_type_substitution_complex() async {
    var library = await buildLibrary('''
class Base<T> {
  Base.ctor(T t, List<T> l);
}
class M {}
class MixinApp<U> = Base<List<U>> with M;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class Base @6
          reference: <testLibraryFragment>::@class::Base
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @11
              defaultType: dynamic
          constructors
            ctor @23
              reference: <testLibraryFragment>::@class::Base::@constructor::ctor
              enclosingElement: <testLibraryFragment>::@class::Base
              periodOffset: 22
              nameEnd: 27
              parameters
                requiredPositional t @30
                  type: T
                requiredPositional l @41
                  type: List<T>
        class M @53
          reference: <testLibraryFragment>::@class::M
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::M::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::M
        class alias MixinApp @64
          reference: <testLibraryFragment>::@class::MixinApp
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant U @73
              defaultType: dynamic
          supertype: Base<List<U>>
          mixins
            M
          constructors
            synthetic ctor @-1
              reference: <testLibraryFragment>::@class::MixinApp::@constructor::ctor
              enclosingElement: <testLibraryFragment>::@class::MixinApp
              parameters
                requiredPositional t @-1
                  type: List<U>
                requiredPositional l @-1
                  type: List<List<U>>
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  period: . @0
                  constructorName: SimpleIdentifier
                    token: ctor @-1
                    staticElement: <testLibraryFragment>::@class::Base::@constructor::ctor
                    staticType: null
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    arguments
                      SimpleIdentifier
                        token: t @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::ctor::@parameter::t
                        staticType: List<U>
                      SimpleIdentifier
                        token: l @-1
                        staticElement: <testLibraryFragment>::@class::MixinApp::@constructor::ctor::@parameter::l
                        staticType: List<List<U>>
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::Base::@constructor::ctor
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::Base::@constructor::ctor
                substitution: {T: List<U>}
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classAlias_with_mixin_members() async {
    var library = await buildLibrary('''
class C = D with E;
class D {}
class E {
  int get a => null;
  void set b(int i) {}
  void f() {}
  int x;
}''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class alias C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          supertype: D
          mixins
            E
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              constantInitializers
                SuperConstructorInvocation
                  superKeyword: super @0
                  argumentList: ArgumentList
                    leftParenthesis: ( @0
                    rightParenthesis: ) @0
                  staticElement: <testLibraryFragment>::@class::D::@constructor::new
              superConstructor: <testLibraryFragment>::@class::D::@constructor::new
        class D @26
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
        class E @37
          reference: <testLibraryFragment>::@class::E
          enclosingElement: <testLibraryFragment>
          fields
            x @105
              reference: <testLibraryFragment>::@class::E::@field::x
              enclosingElement: <testLibraryFragment>::@class::E
              type: int
            synthetic a @-1
              reference: <testLibraryFragment>::@class::E::@field::a
              enclosingElement: <testLibraryFragment>::@class::E
              type: int
            synthetic b @-1
              reference: <testLibraryFragment>::@class::E::@field::b
              enclosingElement: <testLibraryFragment>::@class::E
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::E::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::E
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::E::@getter::x
              enclosingElement: <testLibraryFragment>::@class::E
              returnType: int
            synthetic set x= @-1
              reference: <testLibraryFragment>::@class::E::@setter::x
              enclosingElement: <testLibraryFragment>::@class::E
              parameters
                requiredPositional _x @-1
                  type: int
              returnType: void
            get a @51
              reference: <testLibraryFragment>::@class::E::@getter::a
              enclosingElement: <testLibraryFragment>::@class::E
              returnType: int
            set b= @73
              reference: <testLibraryFragment>::@class::E::@setter::b
              enclosingElement: <testLibraryFragment>::@class::E
              parameters
                requiredPositional i @79
                  type: int
              returnType: void
          methods
            f @92
              reference: <testLibraryFragment>::@class::E::@method::f
              enclosingElement: <testLibraryFragment>::@class::E
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_classes() async {
    var library = await buildLibrary('class C {} class D {}');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
        class D @17
          reference: <testLibraryFragment>::@class::D
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::D::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::D
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_implicitConstructor_named_const() async {
    var library = await buildLibrary('''
class C {
  final Object x;
  const C.named(this.x);
}
const x = C.named(42);
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            final x @25
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: Object
          constructors
            const named @38
              reference: <testLibraryFragment>::@class::C::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::C
              periodOffset: 37
              nameEnd: 43
              parameters
                requiredPositional final this.x @49
                  type: Object
                  field: <testLibraryFragment>::@class::C::@field::x
          accessors
            synthetic get x @-1
              reference: <testLibraryFragment>::@class::C::@getter::x
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: Object
      topLevelVariables
        static const x @61
          reference: <testLibraryFragment>::@topLevelVariable::x
          enclosingElement: <testLibraryFragment>
          type: C
          shouldUseTypeForInitializerInference: false
          constantInitializer
            InstanceCreationExpression
              constructorName: ConstructorName
                type: NamedType
                  name: C @65
                  element: <testLibraryFragment>::@class::C
                  type: C
                period: . @66
                name: SimpleIdentifier
                  token: named @67
                  staticElement: <testLibraryFragment>::@class::C::@constructor::named
                  staticType: null
                staticElement: <testLibraryFragment>::@class::C::@constructor::named
              argumentList: ArgumentList
                leftParenthesis: ( @72
                arguments
                  IntegerLiteral
                    literal: 42 @73
                    staticType: int
                rightParenthesis: ) @75
              staticType: C
      accessors
        synthetic static get x @-1
          reference: <testLibraryFragment>::@getter::x
          enclosingElement: <testLibraryFragment>
          returnType: C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_invalid_setterParameter_fieldFormalParameter() async {
    var library = await buildLibrary('''
class C {
  int foo;
  void set bar(this.foo) {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            foo @16
              reference: <testLibraryFragment>::@class::C::@field::foo
              enclosingElement: <testLibraryFragment>::@class::C
              type: int
            synthetic bar @-1
              reference: <testLibraryFragment>::@class::C::@field::bar
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::C::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: int
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::C::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
            set bar= @32
              reference: <testLibraryFragment>::@class::C::@setter::bar
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.foo @41
                  type: dynamic
                  field: <null>
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_invalid_setterParameter_fieldFormalParameter_self() async {
    var library = await buildLibrary('''
class C {
  set x(this.x) {}
}
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          fields
            synthetic x @-1
              reference: <testLibraryFragment>::@class::C::@field::x
              enclosingElement: <testLibraryFragment>::@class::C
              type: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          accessors
            set x= @16
              reference: <testLibraryFragment>::@class::C::@setter::x
              enclosingElement: <testLibraryFragment>::@class::C
              parameters
                requiredPositional final this.x @23
                  type: dynamic
                  field: <null>
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_unused_type_parameter() async {
    var library = await buildLibrary('''
class C<T> {
  void f() {}
}
C<int> c;
var v = c.f;
''');
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class C @6
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @8
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
          methods
            f @20
              reference: <testLibraryFragment>::@class::C::@method::f
              enclosingElement: <testLibraryFragment>::@class::C
              returnType: void
      topLevelVariables
        static c @36
          reference: <testLibraryFragment>::@topLevelVariable::c
          enclosingElement: <testLibraryFragment>
          type: C<int>
        static v @43
          reference: <testLibraryFragment>::@topLevelVariable::v
          enclosingElement: <testLibraryFragment>
          type: void Function()
          shouldUseTypeForInitializerInference: false
      accessors
        synthetic static get c @-1
          reference: <testLibraryFragment>::@getter::c
          enclosingElement: <testLibraryFragment>
          returnType: C<int>
        synthetic static set c= @-1
          reference: <testLibraryFragment>::@setter::c
          enclosingElement: <testLibraryFragment>
          parameters
            requiredPositional _c @-1
              type: C<int>
          returnType: void
        synthetic static get v @-1
          reference: <testLibraryFragment>::@getter::v
          enclosingElement: <testLibraryFragment>
          returnType: void Function()
        synthetic static set v= @-1
          reference: <testLibraryFragment>::@setter::v
          enclosingElement: <testLibraryFragment>
          parameters
            requiredPositional _v @-1
              type: void Function()
          returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }
}

abstract class ClassElementTest_augmentation extends ElementsBaseTest {
  test_add_augment() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';

class A {
  void foo() {}
}

augment class A {
  void bar() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        class A @36
          reference: <testLibrary>::@fragment::package:test/a.dart::@class::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::A::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::A
          methods
            foo @47
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::A::@method::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::A
              returnType: void
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::bar
              <testLibrary>::@fragment::package:test/a.dart::@class::A::@method::foo
        augment class A @73
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@class::A
          methods
            bar @84
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::bar
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmentation_constField_hasConstConstructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  static const int foo = 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  const A();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            const @43
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            static const foo @66
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 0 @72
                  staticType: int
          accessors
            synthetic static get foo @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmentation_constField_noConstConstructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  static const int foo = 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            static const foo @66
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 0 @72
                  staticType: int
          accessors
            synthetic static get foo @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmentation_finalField_hasConstConstructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  final int foo = 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  const A();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            const @43
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            final foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 0 @65
                  staticType: int
          accessors
            synthetic get foo @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmentation_finalField_noConstConstructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  final int foo = 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            final foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
          accessors
            synthetic get foo @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmentationTarget() async {
    newFile('$testPackageLibPath/a1.dart', r'''
augment library 'test.dart';
import augment 'a11.dart';
import augment 'a12.dart';
augment class A {}
''');

    newFile('$testPackageLibPath/a11.dart', r'''
augment library 'a1.dart';
augment class A {}
''');

    newFile('$testPackageLibPath/a12.dart', r'''
augment library 'a1.dart';
augment class A {}
''');

    newFile('$testPackageLibPath/a2.dart', r'''
augment library 'test.dart';
import augment 'a21.dart';
import augment 'a22.dart';
augment class A {}
''');

    newFile('$testPackageLibPath/a21.dart', r'''
augment library 'a2.dart';
augment class A {}
''');

    newFile('$testPackageLibPath/a22.dart', r'''
augment library 'a2.dart';
augment class A {}
''');

    configuration.withExportScope = true;
    var library = await buildLibrary(r'''
import augment 'a1.dart';
import augment 'a2.dart';
class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a1.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a1.dart
      definingUnit: <testLibrary>::@fragment::package:test/a1.dart
      augmentationImports
        package:test/a11.dart
          enclosingElement: <testLibrary>::@augmentation::package:test/a1.dart
          reference: <testLibrary>::@augmentation::package:test/a11.dart
          definingUnit: <testLibrary>::@fragment::package:test/a11.dart
        package:test/a12.dart
          enclosingElement: <testLibrary>::@augmentation::package:test/a1.dart
          reference: <testLibrary>::@augmentation::package:test/a12.dart
          definingUnit: <testLibrary>::@fragment::package:test/a12.dart
    package:test/a2.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a2.dart
      definingUnit: <testLibrary>::@fragment::package:test/a2.dart
      augmentationImports
        package:test/a21.dart
          enclosingElement: <testLibrary>::@augmentation::package:test/a2.dart
          reference: <testLibrary>::@augmentation::package:test/a21.dart
          definingUnit: <testLibrary>::@fragment::package:test/a21.dart
        package:test/a22.dart
          enclosingElement: <testLibrary>::@augmentation::package:test/a2.dart
          reference: <testLibrary>::@augmentation::package:test/a22.dart
          definingUnit: <testLibrary>::@fragment::package:test/a22.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @58
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a1.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a1.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a1.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @97
          reference: <testLibrary>::@fragment::package:test/a1.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a1.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/a11.dart::@classAugmentation::A
    <testLibrary>::@fragment::package:test/a11.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a11.dart
      enclosingElement3: <testLibrary>::@fragment::package:test/a1.dart
      classes
        augment class A @41
          reference: <testLibrary>::@fragment::package:test/a11.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a11.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a1.dart::@classAugmentation::A
          augmentation: <testLibrary>::@fragment::package:test/a12.dart::@classAugmentation::A
    <testLibrary>::@fragment::package:test/a12.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a12.dart
      enclosingElement3: <testLibrary>::@fragment::package:test/a1.dart
      classes
        augment class A @41
          reference: <testLibrary>::@fragment::package:test/a12.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a12.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a11.dart::@classAugmentation::A
          augmentation: <testLibrary>::@fragment::package:test/a2.dart::@classAugmentation::A
    <testLibrary>::@fragment::package:test/a2.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a2.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @97
          reference: <testLibrary>::@fragment::package:test/a2.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a2.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a12.dart::@classAugmentation::A
          augmentation: <testLibrary>::@fragment::package:test/a21.dart::@classAugmentation::A
    <testLibrary>::@fragment::package:test/a21.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a21.dart
      enclosingElement3: <testLibrary>::@fragment::package:test/a2.dart
      classes
        augment class A @41
          reference: <testLibrary>::@fragment::package:test/a21.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a21.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a2.dart::@classAugmentation::A
          augmentation: <testLibrary>::@fragment::package:test/a22.dart::@classAugmentation::A
    <testLibrary>::@fragment::package:test/a22.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a22.dart
      enclosingElement3: <testLibrary>::@fragment::package:test/a2.dart
      classes
        augment class A @41
          reference: <testLibrary>::@fragment::package:test/a22.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a22.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a21.dart::@classAugmentation::A
  exportedReferences
    declared <testLibraryFragment>::@class::A
  exportNamespace
    A: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a1.dart
    <testLibrary>::@fragment::package:test/a11.dart
    <testLibrary>::@fragment::package:test/a12.dart
    <testLibrary>::@fragment::package:test/a2.dart
    <testLibrary>::@fragment::package:test/a21.dart
    <testLibrary>::@fragment::package:test/a22.dart
  exportedReferences
    declared <testLibraryFragment>::@class::A
  exportNamespace
    A: <testLibraryFragment>::@class::A
''');
  }

  test_augmentationTarget_augmentationThenDeclaration() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';

augment class A {
  void foo1() {}
}

class A {
  void foo2() {}
}

augment class A {
  void foo3() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @44
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0
          methods
            foo1 @55
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0::@method::foo1
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0
              returnType: void
        class A @74
          reference: <testLibrary>::@fragment::package:test/a.dart::@class::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::A::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::A
          methods
            foo2 @85
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::A::@method::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::A
              returnType: void
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@class::A::@method::foo2
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1::@method::foo3
        augment class A @112
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@class::A
          methods
            foo3 @123
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1::@method::foo3
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmentationTarget_no2() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
import augment 'b.dart';
augment class A {
  void foo1() {}
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'a.dart';
augment class A {
  void foo2() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class B {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
      augmentationImports
        package:test/b.dart
          enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
          reference: <testLibrary>::@augmentation::package:test/b.dart
          definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @31
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @68
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          methods
            foo1 @79
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::foo1
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::foo1
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@method::foo2
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibrary>::@fragment::package:test/a.dart
      classes
        augment class A @40
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          methods
            foo2 @51
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@method::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_constructor_augment_field() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment A.foo();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int foo = 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @41
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            augment foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 58
              nameEnd: 62
              augmentationTargetAny: <testLibraryFragment>::@class::A::@getter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructor_augment_getter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment A.foo();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int get foo => 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          accessors
            get foo @45
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            augment foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 58
              nameEnd: 62
              augmentationTargetAny: <testLibraryFragment>::@class::A::@getter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructor_augment_method() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment A.foo();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
            methods
              <testLibraryFragment>::@class::A::@method::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            augment foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 58
              nameEnd: 62
              augmentationTargetAny: <testLibraryFragment>::@class::A::@method::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructor_augment_setter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment A.foo();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  set foo(int _) {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          accessors
            set foo= @41
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @49
                  type: int
              returnType: void
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
            accessors
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            augment foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 58
              nameEnd: 62
              augmentationTargetAny: <testLibraryFragment>::@class::A::@setter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructors_add_named() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  A.named();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            named @51
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 50
              nameEnd: 56
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructors_add_named_generic() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2> {
  A.named(T2 a);
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T1> {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T1 @33
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          augmented
            constructors
              ConstructorMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
                augmentationSubstitution: {T2: T1}
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            named @55
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 54
              nameEnd: 60
              parameters
                requiredPositional a @64
                  type: T2
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructors_add_named_hasUnnamed() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  A.named();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            @37
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            named @51
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 50
              nameEnd: 56
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructors_add_unnamed() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  A();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            @49
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructors_add_unnamed_hasNamed() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  A();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A.named();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            named @39
              reference: <testLibraryFragment>::@class::A::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 38
              nameEnd: 44
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::new
              <testLibraryFragment>::@class::A::@constructor::named
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            @49
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructors_add_useFieldFormal() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  A.named(this.f);
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  final int f;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            final f @47
              reference: <testLibraryFragment>::@class::A::@field::f
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          accessors
            synthetic get f @-1
              reference: <testLibraryFragment>::@class::A::@getter::f
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::f
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
            accessors
              <testLibraryFragment>::@class::A::@getter::f
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            named @51
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 50
              nameEnd: 56
              parameters
                requiredPositional final this.f @62
                  type: int
                  field: <testLibraryFragment>::@class::A::@field::f
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_constructors_add_useFieldInitializer() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  const A.named() : f = 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  final int f;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            final f @47
              reference: <testLibraryFragment>::@class::A::@field::f
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          accessors
            synthetic get f @-1
              reference: <testLibraryFragment>::@class::A::@getter::f
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::f
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
            accessors
              <testLibraryFragment>::@class::A::@getter::f
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            const named @57
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructor::named
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 56
              nameEnd: 62
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: f @67
                    staticElement: <testLibraryFragment>::@class::A::@field::f
                    staticType: null
                  equals: = @69
                  expression: IntegerLiteral
                    literal: 0 @71
                    staticType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_field_augment_constructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 1;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A.foo();
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            foo @39
              reference: <testLibraryFragment>::@class::A::@constructor::foo
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 38
              nameEnd: 42
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              augmentationTargetAny: <testLibraryFragment>::@class::A::@constructor::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_field_augment_field() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 1;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @41
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_1
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_field_augment_field2() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 1;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 2;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @56
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @66
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_1
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_2
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_field_augment_field_afterGetter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 1;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 2;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @56
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @66
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_1
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@getter::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_1
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_field_augment_field_afterSetter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment set foo(int _) {}
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 2;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @56
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @66
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
          augmented
            fields
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          accessors
            augment set foo= @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @69
                  type: int
              returnType: void
              id: setter_1
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_1
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_field_augment_field_augmentedInvocation() async {
    // This is invalid code, but it should not crash.
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {;
  augment static const int foo = augmented();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  static const int foo = 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            static const foo @54
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 0 @60
                  staticType: int
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic static get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment static const foo @75
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                AugmentedInvocation
                  augmentedKeyword: augmented @81
                  arguments: ArgumentList
                    leftParenthesis: ( @90
                    rightParenthesis: ) @91
                  element: <null>
                  staticType: InvalidType
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_field_augment_field_differentTypes() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment double foo = 1.2;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @41
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment foo @64
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: double
              shouldUseTypeForInitializerInference: true
              id: field_1
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_field_augment_field_plus() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment final int foo = augmented + 1;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  final int foo = 0;
  const A();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            final foo @47
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                IntegerLiteral
                  literal: 0 @53
                  staticType: int
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            const @64
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment final foo @67
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              constantInitializer
                BinaryExpression
                  leftOperand: AugmentedExpression
                    augmentedKeyword: augmented @73
                    element: <testLibraryFragment>::@class::A::@field::foo
                    staticType: int
                  operator: + @83
                  rightOperand: IntegerLiteral
                    literal: 1 @85
                    staticType: int
                  staticElement: dart:core::<fragment>::@class::num::@method::+
                  staticInvokeType: num Function(num)
                  staticType: int
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  /// This is not allowed by the specification, but allowed syntactically,
  /// so we need a way to handle it.
  test_augmented_field_augment_getter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 1;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int get foo => 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              getter: getter_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @45
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_1
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_field_augment_method() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 1;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              <testLibraryFragment>::@class::A::@method::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              augmentationTargetAny: <testLibraryFragment>::@class::A::@method::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  /// This is not allowed by the specification, but allowed syntactically,
  /// so we need a way to handle it.
  test_augmented_field_augment_setter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int foo = 1;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  set foo(int _) {}
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              setter: setter_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            set foo= @41
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @49
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            augment foo @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@fieldAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_1
              augmentationTarget: <testLibraryFragment>::@class::A::@field::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_fields_add() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  int foo2 = 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int foo1 = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo1 @41
              reference: <testLibraryFragment>::@class::A::@field::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo1 @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo1= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo1 @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo1
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo1
              <testLibraryFragment>::@class::A::@setter::foo1
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setter::foo2
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            foo2 @53
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_1
              getter: getter_1
              setter: setter_1
          accessors
            synthetic get foo2 @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_1
              variable: field_1
            synthetic set foo2= @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setter::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _foo2 @-1
                  type: int
              returnType: void
              id: setter_1
              variable: field_1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_fields_add_generic() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2> {
  T2 foo2;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T1> {
  T1 foo1;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T1 @33
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo1 @44
              reference: <testLibraryFragment>::@class::A::@field::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              type: T1
              id: field_0
              getter: getter_0
              setter: setter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo1 @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: T1
              id: getter_0
              variable: field_0
            synthetic set foo1= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo1 @-1
                  type: T1
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo1
              FieldMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
                augmentationSubstitution: {T2: T1}
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo1
              <testLibraryFragment>::@class::A::@setter::foo1
              PropertyAccessorMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
                augmentationSubstitution: {T2: T1}
              PropertyAccessorMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setter::foo2
                augmentationSubstitution: {T2: T1}
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            foo2 @56
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: T2
              id: field_1
              getter: getter_1
              setter: setter_1
          accessors
            synthetic get foo2 @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: T2
              id: getter_1
              variable: field_1
            synthetic set foo2= @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setter::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _foo2 @-1
                  type: T2
              returnType: void
              id: setter_1
              variable: field_1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_fields_add_useFieldFormal() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  final int foo;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A(this.foo);
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            @37
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional final this.foo @44
                  type: int
                  field: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            final foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
          accessors
            synthetic get foo @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_fields_add_useFieldInitializer() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  final int foo;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  const A() : foo = 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            const @43
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              constantInitializers
                ConstructorFieldInitializer
                  fieldName: SimpleIdentifier
                    token: foo @49
                    staticElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
                    staticType: null
                  equals: = @53
                  expression: IntegerLiteral
                    literal: 0 @55
                    staticType: int
          augmented
            fields
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            final foo @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
          accessors
            synthetic get foo @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getter_augments_constructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A.foo();
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            foo @39
              reference: <testLibraryFragment>::@class::A::@constructor::foo
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 38
              nameEnd: 42
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::foo
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_0
              variable: <null>
              augmentationTargetAny: <testLibraryFragment>::@class::A::@constructor::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getter_augments_method() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
            methods
              <testLibraryFragment>::@class::A::@method::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_0
              variable: <null>
              augmentationTargetAny: <testLibraryFragment>::@class::A::@method::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getter_augments_setter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  set foo(int _) {}
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              setter: setter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            set foo= @41
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @49
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_0
              variable: <null>
              augmentationTargetAny: <testLibraryFragment>::@class::A::@setter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getters_add() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  int get foo2 => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int get foo1 => 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo1 @-1
              reference: <testLibraryFragment>::@class::A::@field::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              getter: getter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo1 @45
              reference: <testLibraryFragment>::@class::A::@getter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo1
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo1
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            synthetic foo2 @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              id: field_1
              getter: getter_1
          accessors
            get foo2 @57
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_1
              variable: field_1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getters_add_generic() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2> {
  T2 get foo2;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T1> {
  T1 get foo1;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T1 @33
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo1 @-1
              reference: <testLibraryFragment>::@class::A::@field::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              type: T1
              id: field_0
              getter: getter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            abstract get foo1 @48
              reference: <testLibraryFragment>::@class::A::@getter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: T1
              id: getter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo1
              FieldMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
                augmentationSubstitution: {T2: T1}
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo1
              PropertyAccessorMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
                augmentationSubstitution: {T2: T1}
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            synthetic foo2 @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: T2
              id: field_1
              getter: getter_1
          accessors
            abstract get foo2 @60
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getter::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: T2
              id: getter_1
              variable: field_1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getters_augment_field() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @41
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_1
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@getter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getters_augment_field2() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @56
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @66
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@getterAugmentation::foo
              <testLibraryFragment>::@class::A::@setter::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_1
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@getter::foo
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@getterAugmentation::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              returnType: int
              id: getter_2
              variable: field_0
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_getters_augment_getter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo1 => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int get foo1 => 0;
  int get foo2 => 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo1 @-1
              reference: <testLibraryFragment>::@class::A::@field::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              getter: getter_0
            synthetic foo2 @-1
              reference: <testLibraryFragment>::@class::A::@field::foo2
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_1
              getter: getter_1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo1 @45
              reference: <testLibraryFragment>::@class::A::@getter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo1
            get foo2 @66
              reference: <testLibraryFragment>::@class::A::@getter::foo2
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_1
              variable: field_1
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo1
              <testLibraryFragment>::@class::A::@field::foo2
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo1
              <testLibraryFragment>::@class::A::@getter::foo2
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment get foo1 @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo1
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_2
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@getter::foo1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getters_augment_getter2_oneLib_oneTop() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int get foo => 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              getter: getter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @45
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo::@def::0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo::@def::1
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo::@def::0
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_1
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@getter::foo
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo::@def::1
            augment get foo @93
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo::@def::1
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_2
              variable: field_0
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo::@def::0
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_getters_augment_getter2_twoLib() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class A {
  int get foo => 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @56
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              getter: getter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @70
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@getterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_1
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@getter::foo
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@getterAugmentation::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              returnType: int
              id: getter_2
              variable: field_0
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_getters_augment_nothing() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment int get foo => 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {}
''');

    configuration
      ..withConstructors = false
      ..withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          augmented
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment get foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@getterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: int
              id: getter_0
              variable: <null>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_interfaces() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A implements I2 {}
class I2 {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A implements I1 {}
class I1 {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          interfaces
            I1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            interfaces
              I1
              I2
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
        class I1 @56
          reference: <testLibraryFragment>::@class::I1
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::I1::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::I1
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          interfaces
            I2
        class I2 @68
          reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::I2
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_interfaces_chain() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
import augment 'b.dart';
augment class A implements I2 {}
class I2 {}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'a.dart';
augment class A implements I3 {}
class I3 {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A implements I1 {}
class I1 {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
      augmentationImports
        package:test/b.dart
          enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
          reference: <testLibrary>::@augmentation::package:test/b.dart
          definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          interfaces
            I1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            interfaces
              I1
              I2
              I3
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
        class I1 @56
          reference: <testLibraryFragment>::@class::I1
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::I1::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::I1
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @68
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          interfaces
            I2
        class I2 @93
          reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::I2
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibrary>::@fragment::package:test/a.dart
      classes
        augment class A @40
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          interfaces
            I3
        class I3 @65
          reference: <testLibrary>::@fragment::package:test/b.dart::@class::I3
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/b.dart::@class::I3::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@class::I3
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_interfaces_generic() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2> implements I2<T2> {}
class I2<E> {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T> implements I1 {}
class I1 {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @33
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          interfaces
            I1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            interfaces
              I1
              I2<T>
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
        class I1 @59
          reference: <testLibraryFragment>::@class::I1
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::I1::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::I1
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          interfaces
            I2<T2>
        class I2 @76
          reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant E @79
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::I2
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_interfaces_generic_mismatch() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2, T3> implements I2<T2> {}
class I2<E> {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T> implements I1 {}
class I1 {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @33
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          interfaces
            I1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            interfaces
              I1
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
        class I1 @59
          reference: <testLibraryFragment>::@class::I1
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::I1::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::I1
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
            covariant T3 @49
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          interfaces
            I2<T2>
        class I2 @80
          reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant E @83
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@class::I2::@constructor::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@class::I2
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_method_augments_constructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A.foo();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            foo @39
              reference: <testLibraryFragment>::@class::A::@constructor::foo
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 38
              nameEnd: 42
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::foo
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo @62
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTargetAny: <testLibraryFragment>::@class::A::@constructor::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_method_augments_field() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int foo = 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @41
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibraryFragment>::@class::A::@setter::foo
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo @62
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTargetAny: <testLibraryFragment>::@class::A::@getter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_method_augments_getter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int get foo => 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @45
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo @62
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTargetAny: <testLibraryFragment>::@class::A::@getter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_method_augments_setter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  set foo(int _) {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            set foo= @41
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @49
                  type: int
              returnType: void
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@setter::foo
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo @62
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTargetAny: <testLibraryFragment>::@class::A::@setter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_methods() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  void bar() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::bar
              <testLibraryFragment>::@class::A::@method::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            bar @54
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::bar
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_methods_add_withDefaultValue() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  void foo([int x = 42]) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            foo @54
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                optionalPositional default x @63
                  type: int
                  constantInitializer
                    IntegerLiteral
                      literal: 42 @67
                      staticType: int
              returnType: void
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_methods_augment() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment void foo1() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo1() {}
  void foo2() {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo1 @42
              reference: <testLibraryFragment>::@class::A::@method::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo1
            foo2 @59
              reference: <testLibraryFragment>::@class::A::@method::foo2
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo1
              <testLibraryFragment>::@class::A::@method::foo2
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo1 @62
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo1
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTarget: <testLibraryFragment>::@class::A::@method::foo1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_methods_augment2_oneLib_oneTop() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment void foo() {}
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo::@def::0
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo::@def::1
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo @62
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo::@def::0
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTarget: <testLibraryFragment>::@class::A::@method::foo
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo::@def::1
            augment foo @86
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo::@def::1
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo::@def::0
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_methods_augment2_oneLib_twoTop() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment void foo() {}
}
augment class A {
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0::@methodAugmentation::foo
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1
          methods
            augment foo @62
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0
              returnType: void
              augmentationTarget: <testLibraryFragment>::@class::A::@method::foo
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1::@methodAugmentation::foo
        augment class A @87
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0
          methods
            augment foo @106
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::1
              returnType: void
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@def::0::@methodAugmentation::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_methods_augment2_twoLib() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
import augment 'b.dart';
augment class A {
  augment void foo() {}
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'a.dart';
augment class A {
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
      augmentationImports
        package:test/b.dart
          enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
          reference: <testLibrary>::@augmentation::package:test/b.dart
          definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @68
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          methods
            augment foo @87
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTarget: <testLibraryFragment>::@class::A::@method::foo
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibrary>::@fragment::package:test/a.dart
      classes
        augment class A @40
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          methods
            augment foo @59
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              returnType: void
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_methods_generic() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2> {
  T2 bar() => throw 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T> {
  T foo() => throw 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @33
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: T
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              MethodMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::bar
                augmentationSubstitution: {T2: T}
              <testLibraryFragment>::@class::A::@method::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            bar @56
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@method::bar
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: T2
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_methods_generic_augment() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2> {
  augment T2 foo() => throw 0;
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T> {
  T foo() => throw 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @33
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: T
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            methods
              MethodMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
                augmentationSubstitution: {T2: T}
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo @64
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: T2
              augmentationTarget: <testLibraryFragment>::@class::A::@method::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_mixins() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A with M2 {}
mixin M2 {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A with M1 {}
mixin M1 {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          supertype: Object
          mixins
            M1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            mixins
              M1
              M2
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
      mixins
        mixin M1 @50
          reference: <testLibraryFragment>::@mixin::M1
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          mixins
            M2
      mixins
        mixin M2 @62
          reference: <testLibrary>::@fragment::package:test/a.dart::@mixin::M2
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_mixins_inferredTypeArguments() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T2> with M2 {}
mixin M2<U2> on M1<U2> {}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class A<T3> with M3 {}
mixin M3<U3> on M2<U3> {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class B<S> {}
class A<T1> extends B<T1> with M1 {}
mixin M1<U1> on B<U1> {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @56
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant S @58
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
        class A @70
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T1 @72
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          supertype: B<T1>
          mixins
            M1<T1>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::B::@constructor::new
                substitution: {S: T1}
          augmented
            mixins
              M1<T1>
              M2<T1>
              M3<T1>
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
      mixins
        mixin M1 @107
          reference: <testLibraryFragment>::@mixin::M1
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant U1 @110
              defaultType: dynamic
          superclassConstraints
            B<U1>
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          mixins
            M2<T2>
      mixins
        mixin M2 @66
          reference: <testLibrary>::@fragment::package:test/a.dart::@mixin::M2
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant U2 @69
              defaultType: dynamic
          superclassConstraints
            M1<U2>
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          typeParameters
            covariant T3 @45
              defaultType: dynamic
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          mixins
            M3<T3>
      mixins
        mixin M3 @66
          reference: <testLibrary>::@fragment::package:test/b.dart::@mixin::M3
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          typeParameters
            covariant U3 @69
              defaultType: dynamic
          superclassConstraints
            M2<U3>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_augmented_setter_augments_constructor() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment set foo(int _) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A.foo();
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            foo @39
              reference: <testLibraryFragment>::@class::A::@constructor::foo
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 38
              nameEnd: 42
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::foo
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment set foo= @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @69
                  type: int
              returnType: void
              id: setter_0
              variable: <null>
              augmentationTargetAny: <testLibraryFragment>::@class::A::@constructor::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_setter_augments_getter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment set foo(int _) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int get foo => 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo @-1
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              getter: getter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            get foo @45
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment set foo= @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @69
                  type: int
              returnType: void
              id: setter_0
              variable: <null>
              augmentationTargetAny: <testLibraryFragment>::@class::A::@getter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_setter_augments_method() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment set foo(int _) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
            methods
              <testLibraryFragment>::@class::A::@method::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment set foo= @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @69
                  type: int
              returnType: void
              id: setter_0
              variable: <null>
              augmentationTargetAny: <testLibraryFragment>::@class::A::@method::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_setters_add() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  set foo2(int _) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  set foo1(int _) {}
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo1 @-1
              reference: <testLibraryFragment>::@class::A::@field::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              setter: setter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            set foo1= @41
              reference: <testLibraryFragment>::@class::A::@setter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @50
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo1
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@setter::foo1
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setter::foo2
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          fields
            synthetic foo2 @-1
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@field::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              type: int
              id: field_1
              setter: setter_1
          accessors
            set foo2= @53
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setter::foo2
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @62
                  type: int
              returnType: void
              id: setter_1
              variable: field_1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_setters_augment_field() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment set foo(int _) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  int foo = 0;
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            foo @41
              reference: <testLibraryFragment>::@class::A::@field::foo
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              shouldUseTypeForInitializerInference: true
              id: field_0
              getter: getter_0
              setter: setter_0
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            synthetic get foo @-1
              reference: <testLibraryFragment>::@class::A::@getter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: int
              id: getter_0
              variable: field_0
            synthetic set foo= @-1
              reference: <testLibraryFragment>::@class::A::@setter::foo
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _foo @-1
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibraryFragment>::@class::A::@getter::foo
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment set foo= @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @69
                  type: int
              returnType: void
              id: setter_1
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@setter::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_setters_augment_nothing() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment set foo(int _) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {}
''');

    configuration
      ..withConstructors = false
      ..withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          augmented
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment set foo= @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @69
                  type: int
              returnType: void
              id: setter_0
              variable: <null>
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_augmented_setters_augment_setter() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment set foo1(int _) {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  set foo1(int _) {}
  set foo2(int _) {}
}
''');

    configuration.withPropertyLinking = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          fields
            synthetic foo1 @-1
              reference: <testLibraryFragment>::@class::A::@field::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_0
              setter: setter_0
            synthetic foo2 @-1
              reference: <testLibraryFragment>::@class::A::@field::foo2
              enclosingElement: <testLibraryFragment>::@class::A
              type: int
              id: field_1
              setter: setter_1
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          accessors
            set foo1= @41
              reference: <testLibraryFragment>::@class::A::@setter::foo1
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @50
                  type: int
              returnType: void
              id: setter_0
              variable: field_0
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo1
            set foo2= @62
              reference: <testLibraryFragment>::@class::A::@setter::foo2
              enclosingElement: <testLibraryFragment>::@class::A
              parameters
                requiredPositional _ @71
                  type: int
              returnType: void
              id: setter_1
              variable: field_1
          augmented
            fields
              <testLibraryFragment>::@class::A::@field::foo1
              <testLibraryFragment>::@class::A::@field::foo2
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
            accessors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo1
              <testLibraryFragment>::@class::A::@setter::foo2
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          accessors
            augment set foo1= @61
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@setterAugmentation::foo1
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              parameters
                requiredPositional _ @70
                  type: int
              returnType: void
              id: setter_2
              variable: field_0
              augmentationTarget: <testLibraryFragment>::@class::A::@setter::foo1
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  /// Invalid augmentation of class with mixin does not "own" the name.
  test_augmentedBy_mixin2() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';

augment mixin A {}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';

augment mixin A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';

class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @57
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      mixins
        augment mixin A @44
          reference: <testLibrary>::@fragment::package:test/a.dart::@mixinAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTargetAny: <testLibraryFragment>::@class::A
          superclassConstraints
            Object
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      mixins
        augment mixin A @44
          reference: <testLibrary>::@fragment::package:test/b.dart::@mixinAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTargetAny: <testLibraryFragment>::@class::A
          superclassConstraints
            Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  /// Invalid augmentation of class with mixin does not "own" the name.
  /// When a valid class augmentation follows, it can use the name.
  test_augmentedBy_mixin_class() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';

augment mixin A {}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';

augment class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';

class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @57
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      mixins
        augment mixin A @44
          reference: <testLibrary>::@fragment::package:test/a.dart::@mixinAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTargetAny: <testLibraryFragment>::@class::A
          superclassConstraints
            Object
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @44
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_constructors_augment2() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment A.named();
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class A {
  augment A.named();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class A {
  A.named();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @56
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            named @64
              reference: <testLibraryFragment>::@class::A::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 63
              nameEnd: 69
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::named
          augmented
            constructors
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@constructorAugmentation::named
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          constructors
            augment named @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::named
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 58
              nameEnd: 64
              augmentationTarget: <testLibraryFragment>::@class::A::@constructor::named
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@constructorAugmentation::named
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            augment named @59
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A::@constructorAugmentation::named
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::A
              periodOffset: 58
              nameEnd: 64
              augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::named
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_constructors_augment_named() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment A.named();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A.named();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            named @39
              reference: <testLibraryFragment>::@class::A::@constructor::named
              enclosingElement: <testLibraryFragment>::@class::A
              periodOffset: 38
              nameEnd: 44
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::named
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::named
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            augment named @59
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::named
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              periodOffset: 58
              nameEnd: 64
              augmentationTarget: <testLibraryFragment>::@class::A::@constructor::named
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_constructors_augment_unnamed() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A {
  augment A();
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  A();
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            @37
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::new
          augmented
            constructors
              <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
          constructors
            augment @57
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@constructorAugmentation::new
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              augmentationTarget: <testLibraryFragment>::@class::A::@constructor::new
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_inferTypes_method_ofAugment() async {
    newFile('$testPackageLibPath/a.dart', r'''
class A {
  int foo(String a) => 0;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class B {
  foo(a) => 0;
}
''');

    var library = await buildLibrary(r'''
import 'a.dart';
import augment 'b.dart';

class B extends A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class B @49
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: package:test/a.dart::<fragment>::@class::A::@constructor::new
          augmented
            constructors
              <testLibraryFragment>::@class::B::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B::@method::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class B @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibraryFragment>::@class::B
          methods
            foo @49
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B::@method::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
              parameters
                requiredPositional a @53
                  type: String
              returnType: int
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_inferTypes_method_usingAugmentation_interface() async {
    newFile('$testPackageLibPath/a.dart', r'''
class A {
  int foo(String a) => 0;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
import 'a.dart';
augment class B implements A {}
''');

    var library = await buildLibrary(r'''
import augment 'b.dart';

class B {
  foo(a) => 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibrary>::@fragment::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @32
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
          methods
            foo @38
              reference: <testLibraryFragment>::@class::B::@method::foo
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional a @42
                  type: String
              returnType: int
          augmented
            interfaces
              A
            constructors
              <testLibraryFragment>::@class::B::@constructor::new
            methods
              <testLibraryFragment>::@class::B::@method::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibrary>::@fragment::package:test/b.dart
      classes
        augment class B @60
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibraryFragment>::@class::B
          interfaces
            A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/b.dart
      libraryImports
        package:test/a.dart
''');
  }

  test_inferTypes_method_usingAugmentation_mixin() async {
    newFile('$testPackageLibPath/a.dart', r'''
mixin A {
  int foo(String a) => 0;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
import 'a.dart';
augment class B with A {}
''');

    var library = await buildLibrary(r'''
import augment 'b.dart';

class B {
  foo(a) => 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibrary>::@fragment::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class B @32
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
          methods
            foo @38
              reference: <testLibraryFragment>::@class::B::@method::foo
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional a @42
                  type: String
              returnType: int
          augmented
            mixins
              A
            constructors
              <testLibraryFragment>::@class::B::@constructor::new
            methods
              <testLibraryFragment>::@class::B::@method::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibrary>::@fragment::package:test/b.dart
      classes
        augment class B @60
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibraryFragment>::@class::B
          mixins
            A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/b.dart
      libraryImports
        package:test/a.dart
''');
  }

  test_inferTypes_method_withAugment() async {
    newFile('$testPackageLibPath/a.dart', r'''
class A {
  int foo(String a) => 0;
}
''');

    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class B {
  augment foo(a) => 0;
}
''');

    var library = await buildLibrary(r'''
import 'a.dart';
import augment 'b.dart';

class B extends A {
  foo(a) => 0;
}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  libraryImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      enclosingElement3: <testLibraryFragment>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      libraryImports
        package:test/a.dart
          enclosingElement: <testLibrary>
          enclosingElement3: <testLibraryFragment>
      classes
        class B @49
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: package:test/a.dart::<fragment>::@class::A::@constructor::new
          methods
            foo @65
              reference: <testLibraryFragment>::@class::B::@method::foo
              enclosingElement: <testLibraryFragment>::@class::B
              parameters
                requiredPositional a @69
                  type: String
              returnType: int
              augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B::@methodAugmentation::foo
          augmented
            constructors
              <testLibraryFragment>::@class::B::@constructor::new
            methods
              <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B::@methodAugmentation::foo
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class B @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibraryFragment>::@class::B
          methods
            augment foo @57
              reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::B
              parameters
                requiredPositional a @61
                  type: String
              returnType: int
              augmentationTarget: <testLibraryFragment>::@class::B::@method::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
      libraryImports
        package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_methods_typeParameterCountMismatch() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T> {
  augment void foo() {}
}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A {
  void foo() {}
  void bar() {}
}
''');

    configuration.withConstructors = false;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          methods
            foo @42
              reference: <testLibraryFragment>::@class::A::@method::foo
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
              augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
            bar @58
              reference: <testLibraryFragment>::@class::A::@method::bar
              enclosingElement: <testLibraryFragment>::@class::A
              returnType: void
          augmented
            methods
              <testLibraryFragment>::@class::A::@method::bar
              MethodMember
                base: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
                augmentationSubstitution: {T: InvalidType}
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::A
          methods
            augment foo @65
              reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A::@methodAugmentation::foo
              enclosingElement: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
              returnType: void
              augmentationTarget: <testLibraryFragment>::@class::A::@method::foo
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_modifiers_abstract() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment abstract class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
abstract class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract class A @40
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment abstract class A @52
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_modifiers_base() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment base class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
base class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        base class A @36
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment base class A @48
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_modifiers_final() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment final class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
final class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        final class A @37
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment final class A @49
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_modifiers_interface() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment interface class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
interface class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        interface class A @41
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment interface class A @53
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_modifiers_macro() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment macro class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
macro class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        macro class A @37
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment macro class A @49
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_modifiers_mixin() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment mixin class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
mixin class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        mixin class A @37
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment mixin class A @49
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_modifiers_sealed() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment sealed class A {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
sealed class A {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        abstract sealed class A @38
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment abstract sealed class A @50
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_notAugmented_interfaces() async {
    var library = await buildLibrary(r'''
class A implements I {}
class I {}
''');

    configuration.withAugmentedWithoutAugmentation = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          interfaces
            I
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            interfaces
              I
        class I @30
          reference: <testLibraryFragment>::@class::I
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::I::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::I
          augmented
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_notAugmented_mixins() async {
    var library = await buildLibrary(r'''
class A implements M {}
mixin M {}
''');

    configuration.withAugmentedWithoutAugmentation = true;
    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @6
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          interfaces
            M
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            interfaces
              M
      mixins
        mixin M @30
          reference: <testLibraryFragment>::@mixin::M
          enclosingElement: <testLibraryFragment>
          superclassConstraints
            Object
          augmented
            superclassConstraints
              Object
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
''');
  }

  test_notSimplyBounded_self() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T extends A> {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T extends A> {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        notSimplyBounded class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @33
              bound: A<dynamic>
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T @45
              bound: A<dynamic>
              defaultType: A<dynamic>
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_supertype_fromAugmentation() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class B<T2> extends A<T2> {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T> {}
class B<T1> {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @33
              defaultType: dynamic
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @45
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T1 @47
              defaultType: dynamic
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::B
          supertype: A<T1>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
              superConstructor: ConstructorMember
                base: <testLibraryFragment>::@class::A::@constructor::new
                substitution: {T: T1}
          augmented
            constructors
              <testLibraryFragment>::@class::B::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class B @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::B
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T2 @45
              defaultType: dynamic
          augmentationTarget: <testLibraryFragment>::@class::B
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }

  test_supertype_fromAugmentation2() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class C extends A {}
''');

    // `extends B` should be ignored, we already have `extends A`
    newFile('$testPackageLibPath/b.dart', r'''
augment library 'test.dart';
augment class C extends B {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
import augment 'b.dart';
class A {}
class B {}
class C {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
    package:test/b.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/b.dart
      definingUnit: <testLibrary>::@fragment::package:test/b.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @56
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
        class B @67
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
        class C @78
          reference: <testLibraryFragment>::@class::C
          enclosingElement: <testLibraryFragment>
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::C
          supertype: A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::C::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::C
              superConstructor: <testLibraryFragment>::@class::A::@constructor::new
          augmented
            constructors
              <testLibraryFragment>::@class::C::@constructor::new
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class C @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::C
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          augmentationTarget: <testLibraryFragment>::@class::C
          augmentation: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::C
    <testLibrary>::@fragment::package:test/b.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/b.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class C @43
          reference: <testLibrary>::@fragment::package:test/b.dart::@classAugmentation::C
          enclosingElement: <testLibrary>::@fragment::package:test/b.dart
          augmentationTarget: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::C
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
    <testLibrary>::@fragment::package:test/b.dart
''');
  }

  test_typeParameters_defaultType() async {
    newFile('$testPackageLibPath/a.dart', r'''
augment library 'test.dart';
augment class A<T extends B> {}
''');

    var library = await buildLibrary(r'''
import augment 'a.dart';
class A<T extends B> {}
class B {}
''');

    checkElementText(library, r'''
library
  reference: <testLibrary>
  definingUnit: <testLibraryFragment>
  augmentationImports
    package:test/a.dart
      enclosingElement: <testLibrary>
      reference: <testLibrary>::@augmentation::package:test/a.dart
      definingUnit: <testLibrary>::@fragment::package:test/a.dart
  units
    <testLibraryFragment>
      enclosingElement: <testLibrary>
      classes
        class A @31
          reference: <testLibraryFragment>::@class::A
          enclosingElement: <testLibraryFragment>
          typeParameters
            covariant T @33
              bound: B
              defaultType: B
          augmentation: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::A::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::A
          augmented
            constructors
              <testLibraryFragment>::@class::A::@constructor::new
        class B @55
          reference: <testLibraryFragment>::@class::B
          enclosingElement: <testLibraryFragment>
          constructors
            synthetic @-1
              reference: <testLibraryFragment>::@class::B::@constructor::new
              enclosingElement: <testLibraryFragment>::@class::B
    <testLibrary>::@fragment::package:test/a.dart
      enclosingElement: <testLibrary>::@augmentation::package:test/a.dart
      enclosingElement3: <testLibraryFragment>
      classes
        augment class A @43
          reference: <testLibrary>::@fragment::package:test/a.dart::@classAugmentation::A
          enclosingElement: <testLibrary>::@fragment::package:test/a.dart
          typeParameters
            covariant T @45
              bound: B
              defaultType: B
          augmentationTarget: <testLibraryFragment>::@class::A
----------------------------------------
library
  reference: <testLibrary>
  fragments
    <testLibraryFragment>
    <testLibrary>::@fragment::package:test/a.dart
''');
  }
}

@reflectiveTest
class ClassElementTest_augmentation_fromBytes
    extends ClassElementTest_augmentation {
  @override
  bool get keepLinkingLibraries => false;
}

@reflectiveTest
class ClassElementTest_augmentation_keepLinking
    extends ClassElementTest_augmentation {
  @override
  bool get keepLinkingLibraries => true;
}

@reflectiveTest
class ClassElementTest_fromBytes extends ClassElementTest {
  @override
  bool get keepLinkingLibraries => false;
}

@reflectiveTest
class ClassElementTest_keepLinking extends ClassElementTest {
  @override
  bool get keepLinkingLibraries => true;
}

// TODO(scheglov): This is duplicate.
extension on ElementTextConfiguration {
  void forPromotableFields({
    Set<String> classNames = const {},
    Set<String> enumNames = const {},
    Set<String> extensionTypeNames = const {},
    Set<String> mixinNames = const {},
    Set<String> fieldNames = const {},
  }) {
    filter = (e) {
      if (e is ClassElement) {
        return classNames.contains(e.name);
      } else if (e is ConstructorElement) {
        return false;
      } else if (e is EnumElement) {
        return enumNames.contains(e.name);
      } else if (e is ExtensionTypeElement) {
        return extensionTypeNames.contains(e.name);
      } else if (e is FieldElement) {
        return fieldNames.isEmpty || fieldNames.contains(e.name);
      } else if (e is MixinElement) {
        return mixinNames.contains(e.name);
      } else if (e is PartElement) {
        return false;
      } else if (e is PropertyAccessorElement) {
        return false;
      }
      return true;
    };
  }
}
