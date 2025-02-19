// Copyright (c) 2017, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:analyzer/src/dart/element/field_name_non_promotability_info.dart';
import 'package:analyzer/src/summary2/export.dart';
import 'package:analyzer/src/summary2/macro_application_error.dart';
import 'package:analyzer/src/summary2/macro_type_location.dart';
import 'package:analyzer/src/task/inference_error.dart';
import 'package:analyzer_utilities/testing/tree_string_sink.dart';
import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

import '../../util/element_printer.dart';
import 'resolved_ast_printer.dart';

String getLibraryText({
  required LibraryElementImpl library,
  required ElementTextConfiguration configuration,
}) {
  var buffer = StringBuffer();
  var sink = TreeStringSink(
    sink: buffer,
    indent: '',
  );
  var elementPrinter = ElementPrinter(
    sink: sink,
    configuration: configuration.elementPrinterConfiguration,
  );
  var writer = _ElementWriter(
    sink: sink,
    elementPrinter: elementPrinter,
    configuration: configuration,
  );
  writer.writeLibraryElement(library);

  sink.writeln('-' * 40);
  var writer2 = _Element2Writer(
    sink: sink,
    elementPrinter: elementPrinter,
    configuration: configuration,
  );
  writer2.writeLibraryElement(library);
  return buffer.toString();
}

class ElementTextConfiguration {
  ElementPrinterConfiguration elementPrinterConfiguration =
      ElementPrinterConfiguration();
  bool Function(Object) filter;
  List<Pattern>? macroDiagnosticMessagePatterns;
  bool withAllSupertypes = false;
  bool withAugmentedWithoutAugmentation = false;
  bool withCodeRanges = false;
  bool withConstantInitializers = true;
  bool withConstructors = true;
  bool withDisplayName = false;
  bool withExportScope = false;
  bool withFunctionTypeParameters = false;
  bool withImports = true;
  bool withLibraryAugmentations = false;
  bool withMacroStackTraces = false;
  bool withMetadata = true;
  bool withNonSynthetic = false;
  bool withPropertyLinking = false;
  bool withRedirectedConstructors = false;
  bool withReturnType = true;
  bool withSyntheticDartCoreImport = false;

  ElementTextConfiguration({
    this.filter = _filterTrue,
  });

  static bool _filterTrue(Object element) => true;
}

/// Writes the canonical text presentation of elements.
abstract class _AbstractElementWriter {
  final TreeStringSink _sink;
  final ElementPrinter _elementPrinter;
  final ElementTextConfiguration configuration;
  final _IdMap _idMap = _IdMap();

  _AbstractElementWriter({
    required TreeStringSink sink,
    required ElementPrinter elementPrinter,
    required this.configuration,
  })  : _sink = sink,
        _elementPrinter = elementPrinter;

  ResolvedAstPrinter _createAstPrinter() {
    return ResolvedAstPrinter(
      sink: _sink,
      elementPrinter: _elementPrinter,
      configuration: ResolvedNodeTextConfiguration()
        // TODO(scheglov): https://github.com/dart-lang/sdk/issues/49101
        ..withParameterElements = false,
      withOffsets: true,
    );
  }

  void _writeDirectiveUri(DirectiveUri uri) {
    if (uri is DirectiveUriWithAugmentationImpl) {
      _sink.write('${uri.augmentation.source.uri}');
    } else if (uri is DirectiveUriWithLibraryImpl) {
      _sink.write('${uri.library.source.uri}');
    } else if (uri is DirectiveUriWithUnit) {
      _sink.write('${uri.unit.source.uri}');
    } else if (uri is DirectiveUriWithSource) {
      _sink.write("source '${uri.source.uri}'");
    } else if (uri is DirectiveUriWithRelativeUri) {
      _sink.write("relativeUri '${uri.relativeUri}'");
    } else if (uri is DirectiveUriWithRelativeUriString) {
      _sink.write("relativeUriString '${uri.relativeUriString}'");
    } else {
      _sink.write('noRelativeUriString');
    }
  }

  void _writeElements<T extends Object>(
    String name,
    List<T> elements,
    void Function(T) write,
  ) {
    var filtered = elements.where(configuration.filter).toList();
    if (filtered.isNotEmpty) {
      _sink.writelnWithIndent(name);
      _sink.withIndent(() {
        for (var element in filtered) {
          write(element);
        }
      });
    }
  }

  void _writeExportedReferences(LibraryElementImpl e) {
    var exportedReferences = e.exportedReferences.toList();
    exportedReferences.sortBy((e) => e.reference.toString());

    for (var exported in exportedReferences) {
      _sink.writeIndentedLine(() {
        if (exported is ExportedReferenceDeclared) {
          _sink.write('declared ');
        } else if (exported is ExportedReferenceExported) {
          _sink.write('exported${exported.locations} ');
        }
        _elementPrinter.writeReference(exported.reference);
      });
    }
  }

  void _writeFieldNameNonPromotabilityInfo(
    Map<String, FieldNameNonPromotabilityInfo>? info,
  ) {
    if (info == null || info.isEmpty) {
      return;
    }

    _sink.writelnWithIndent('fieldNameNonPromotabilityInfo');
    _sink.withIndent(() {
      for (var entry in info.entries) {
        _sink.writelnWithIndent(entry.key);
        _sink.withIndent(() {
          _elementPrinter.writeElementList(
            'conflictingFields',
            entry.value.conflictingFields,
          );
          _elementPrinter.writeElementList(
            'conflictingGetters',
            entry.value.conflictingGetters,
          );
          _elementPrinter.writeElementList(
            'conflictingNsmClasses',
            entry.value.conflictingNsmClasses,
          );
        });
      }
    });
  }

  void _writeNode(AstNode node) {
    _sink.writeIndent();
    node.accept(
      _createAstPrinter(),
    );
  }

  void _writeReference(ElementImpl e) {
    if (e.reference case var reference?) {
      _sink.writeIndentedLine(() {
        _sink.write('reference: ');
        _elementPrinter.writeReference(reference);
      });
    }
  }
}

/// Writes the canonical text presentation of elements.
class _Element2Writer extends _AbstractElementWriter {
  _Element2Writer({
    required super.sink,
    required super.elementPrinter,
    required super.configuration,
  });

  void writeLibraryElement(LibraryElement2 e) {
    expect(e.enclosingElement2, isNull);

    _sink.writelnWithIndent('library');
    _sink.withIndent(() {
      _writeReference(e as ElementImpl);

      var name = e.name;
      if (name != null && name.isNotEmpty) {
        _sink.writelnWithIndent('name: $name');
      }

      _writeDocumentation(e.documentationComment);
      _writeMetadata(e.metadata);
      _writeSinceSdkVersion(e.sinceSdkVersion);

      // _writeElements(
      //   'libraryExports',
      //   e.libraryExports,
      //   _writeLibraryExportElement,
      // );

      // TODO(brianwilkerson): Consider adding `fragments` as a convenience
      //  getter in `_Fragmented`
      var fragments = <LibraryFragment>[];
      for (LibraryFragment? fragment = e.firstFragment;
          fragment != null;
          fragment = fragment.nextFragment) {
        fragments.add(fragment);
        expect(fragment.element, same(e));
      }

      _writeElements('fragments', fragments, _writeLibraryFragment);

      if (configuration.withExportScope) {
        _sink.writelnWithIndent('exportedReferences');
        _sink.withIndent(() {
          _writeExportedReferences(e as LibraryElementImpl);
        });
        _sink.writelnWithIndent('exportNamespace');
        _sink.withIndent(() {
          _writeExportNamespace(e);
        });
      }

      _writeFieldNameNonPromotabilityInfo(
          (e as LibraryElementImpl).fieldNameNonPromotabilityInfo);
      _writeMacroDiagnostics(e);
    });
  }

  void _writeDocumentation(String? documentation) {
    if (documentation != null) {
      var str = documentation;
      str = str.replaceAll('\n', r'\n');
      str = str.replaceAll('\r', r'\r');
      _sink.writelnWithIndent('documentationComment: $str');
    }
  }

  void _writeExportNamespace(LibraryElement2 e) {
    var map = e.exportNamespace.definedNames;
    var sortedEntries = map.entries.sortedBy((entry) => entry.key);
    for (var entry in sortedEntries) {
      _elementPrinter.writeNamedElement(entry.key, entry.value);
    }
  }

  void _writeLibraryFragment(LibraryFragment f) {
    var reference = (f as CompilationUnitElementImpl).reference!;
    _sink.writeIndentedLine(() {
      _elementPrinter.writeReference(reference);
    });

    _sink.withIndent(() {
      _writeMetadata(f.metadata);

      if (configuration.withImports) {
        var imports = f.libraryImports2.where((import) {
          return configuration.withSyntheticDartCoreImport ||
              !import.isSynthetic;
        }).toList();
        _writeElements(
          'libraryImports',
          imports,
          _writeLibraryImport,
        );
        _writeElements('prefixes', f.prefixes, _writePrefixElement);
      }
    });
  }

  void _writeLibraryImport(LibraryImport e) {
    (e as LibraryImportElementImpl).location;

    _sink.writeIndentedLine(() {
      _writeDirectiveUri(e.uri);
      _sink.writeIf(e.isSynthetic, ' synthetic');
      // _writeImportElementPrefix(e.prefix);
    });

    _sink.withIndent(() {
      _writeReference(e);
      // _writeEnclosingElement(e);
      _writeMetadata(e.metadata);
      // _writeNamespaceCombinators(e.combinators);
    });
  }

  void _writeMacroDiagnostics(Element2 e) {
    void writeTypeAnnotationLocation(TypeAnnotationLocation location) {
      switch (location) {
        case AliasedTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('AliasedTypeLocation');
        case ElementTypeLocation():
          _sink.writelnWithIndent('ElementTypeLocation');
          _sink.withIndent(() {
            _elementPrinter.writeNamedElement('element', location.element);
          });
        case ExtendsClauseTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('ExtendsClauseTypeLocation');
        case FormalParameterTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('FormalParameterTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case ListIndexTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('ListIndexTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case RecordNamedFieldTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('RecordNamedFieldTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case RecordPositionalFieldTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('RecordPositionalFieldTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case ReturnTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('ReturnTypeLocation');
        case VariableTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('VariableTypeLocation');
        default:
          // TODO(scheglov): Handle this case.
          throw UnimplementedError('${location.runtimeType}');
      }
    }

    /// Returns `true` if patterns were printed.
    /// Returns `false` if no patterns configured.
    bool printMessagePatterns(String message) {
      var patterns = configuration.macroDiagnosticMessagePatterns;
      if (patterns == null) {
        return false;
      }

      _sink.writelnWithIndent('contains');
      _sink.withIndent(() {
        for (var pattern in patterns) {
          if (message.contains(pattern)) {
            _sink.writelnWithIndent(pattern);
          }
        }
      });
      return true;
    }

    void writeMessage(MacroDiagnosticMessage object) {
      // Write the message.
      if (!printMessagePatterns(object.message)) {
        var message = object.message;
        const stackTraceText = '#0';
        var stackTraceIndex = message.indexOf(stackTraceText);
        if (stackTraceIndex >= 0) {
          var end = stackTraceIndex + stackTraceText.length;
          var withoutStackTrace = message.substring(0, end);
          if (configuration.withMacroStackTraces) {
            _sink.writelnWithIndent('message:\n$message');
          } else {
            _sink.writelnWithIndent('message:\n$withoutStackTrace <cut>');
          }
        } else {
          _sink.writelnWithIndent('message: $message');
        }
      }
      // Write the target.
      var target = object.target;
      switch (target) {
        case ApplicationMacroDiagnosticTarget():
          _sink.writelnWithIndent('target: ApplicationMacroDiagnosticTarget');
          _sink.withIndent(() {
            _sink.writelnWithIndent(
              'annotationIndex: ${target.annotationIndex}',
            );
          });
        case ElementMacroDiagnosticTarget():
          _sink.writelnWithIndent('target: ElementMacroDiagnosticTarget');
          _sink.withIndent(() {
            _elementPrinter.writeNamedElement('element', target.element);
          });
        case ElementAnnotationMacroDiagnosticTarget():
          _sink.writelnWithIndent(
            'target: ElementAnnotationMacroDiagnosticTarget',
          );
          _sink.withIndent(() {
            _elementPrinter.writeNamedElement('element', target.element);
            _sink.writelnWithIndent(
              'annotationIndex: ${target.annotationIndex}',
            );
          });
        case TypeAnnotationMacroDiagnosticTarget():
          _sink.writelnWithIndent(
            'target: TypeAnnotationMacroDiagnosticTarget',
          );
          _sink.withIndent(() {
            writeTypeAnnotationLocation(target.location);
          });
      }
    }

    if (e case MacroTargetElement macroTarget) {
      _sink.writeElements(
        'macroDiagnostics',
        macroTarget.macroDiagnostics,
        (diagnostic) {
          switch (diagnostic) {
            case ArgumentMacroDiagnostic():
              _sink.writelnWithIndent('ArgumentMacroDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _sink.writelnWithIndent(
                  'argumentIndex: ${diagnostic.argumentIndex}',
                );
                _sink.writelnWithIndent('message: ${diagnostic.message}');
              });
            case DeclarationsIntrospectionCycleDiagnostic():
              _sink.writelnWithIndent(
                'DeclarationsIntrospectionCycleDiagnostic',
              );
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _elementPrinter.writeNamedElement(
                  'introspectedElement',
                  diagnostic.introspectedElement,
                );
                _sink.writeElements(
                  'components',
                  diagnostic.components,
                  (component) {
                    _sink.writelnWithIndent(
                      'DeclarationsIntrospectionCycleComponent',
                    );
                    _sink.withIndent(() {
                      _elementPrinter.writeNamedElement(
                        'element',
                        component.element,
                      );
                      _sink.writelnWithIndent(
                        'annotationIndex: ${component.annotationIndex}',
                      );
                      _elementPrinter.writeNamedElement(
                        'introspectedElement',
                        component.introspectedElement,
                      );
                    });
                  },
                );
              });
            case ExceptionMacroDiagnostic():
              _sink.writelnWithIndent('ExceptionMacroDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                if (!printMessagePatterns(diagnostic.message)) {
                  _sink.writelnWithIndent(
                    'message: ${diagnostic.message}',
                  );
                }
                if (configuration.withMacroStackTraces) {
                  _sink.writelnWithIndent(
                    'stackTrace:\n${diagnostic.stackTrace}',
                  );
                }
              });
            case InvalidMacroTargetDiagnostic():
              _sink.writelnWithIndent('InvalidMacroTargetDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _sink.writeElements(
                  'supportedKinds',
                  diagnostic.supportedKinds,
                  (kindName) {
                    _sink.writelnWithIndent(kindName);
                  },
                );
              });
            case MacroDiagnostic():
              _sink.writelnWithIndent('MacroDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent('message: MacroDiagnosticMessage');
                _sink.withIndent(() {
                  writeMessage(diagnostic.message);
                });
                _sink.writeElements(
                  'contextMessages',
                  diagnostic.contextMessages,
                  (message) {
                    _sink.writelnWithIndent('MacroDiagnosticMessage');
                    _sink.withIndent(() {
                      writeMessage(message);
                    });
                  },
                );
                _sink.writelnWithIndent(
                  'severity: ${diagnostic.severity.name}',
                );
                if (diagnostic.correctionMessage case var correctionMessage?) {
                  _sink.writelnWithIndent(
                    'correctionMessage: $correctionMessage',
                  );
                }
              });
            case NotAllowedDeclarationDiagnostic():
              _sink.writelnWithIndent('NotAllowedDeclarationDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _sink.writelnWithIndent(
                  'phase: ${diagnostic.phase.name}',
                );
                var nodeRangesStr = diagnostic.nodeRanges
                    .map((r) => '(${r.offset}, ${r.length})')
                    .join(' ');
                _sink.writelnWithIndent('nodeRanges: $nodeRangesStr');
                _sink.writeln('---');
                _sink.write(diagnostic.code);
                _sink.writeln('---');
              });
          }
        },
      );
    }
  }

  void _writeMetadata(List<ElementAnnotation> annotations) {
    if (configuration.withMetadata) {
      if (annotations.isNotEmpty) {
        _sink.writelnWithIndent('metadata');
        _sink.withIndent(() {
          for (var annotation in annotations) {
            annotation as ElementAnnotationImpl;
            _writeNode(annotation.annotationAst);
          }
        });
      }
    }
  }

  void _writeName(Element2 e) {
    String name;
    switch (e) {
      case ExtensionElement(name: null):
        name = '<null>';
      default:
        name = e.name!;
    }

    if (e is SetterElement) {
      expect(name, endsWith('='));
    }

    _sink.write(name);
    // TODO(brianwilkerson): Figure out how to determine whether an element has
    //  a `nameOffset`.
    // _sink.write(name.isNotEmpty ? ' @' : '@');
    // _sink.write(e.nameOffset);
  }

  void _writePrefixElement(PrefixElement2 e) {
    _sink.writeIndentedLine(() {
      _writeName(e);
    });

    _sink.withIndent(() {
      _writeReference(e as ElementImpl);
      // _writeEnclosingElement(e);
    });
  }

  void _writeSinceSdkVersion(Version? version) {
    if (version != null) {
      _sink.writelnWithIndent('sinceSdkVersion: $version');
    }
  }
}

/// Writes the canonical text presentation of elements.
class _ElementWriter extends _AbstractElementWriter {
  _ElementWriter({
    required super.sink,
    required super.elementPrinter,
    required super.configuration,
  });

  void writeLibraryElement(LibraryElementImpl e) {
    expect(e.enclosingElement, isNull);

    _sink.writelnWithIndent('library');
    _sink.withIndent(() {
      var name = e.name;
      if (name.isNotEmpty) {
        _sink.writelnWithIndent('name: $name');
      }

      var nameOffset = e.nameOffset;
      if (nameOffset != -1) {
        _sink.writelnWithIndent('nameOffset: $nameOffset');
      }

      _writeLibraryOrAugmentationElement(e);

      for (var part in e.parts) {
        if (part.uri case DirectiveUriWithUnitImpl uri) {
          expect(uri.unit.libraryOrAugmentationElement, same(e));
        }
      }

      _writeElements('parts', e.parts, (part) {
        _sink.writelnWithIndent(_idMap[part]);
      });

      _writeElements('units', e.units, (unit) {
        _sink.writeIndent();
        _elementPrinter.writeElement(unit);
        _sink.withIndent(() {
          _writeUnitElement(unit);
        });
      });

      // All fragments have this library.
      for (var unit in e.units) {
        expect(unit.library, same(e));
      }

      if (configuration.withExportScope) {
        _sink.writelnWithIndent('exportedReferences');
        _sink.withIndent(() {
          _writeExportedReferences(e);
        });
        _sink.writelnWithIndent('exportNamespace');
        _sink.withIndent(() {
          _writeExportNamespace(e);
        });
      }

      _writeFieldNameNonPromotabilityInfo(e.fieldNameNonPromotabilityInfo);
      _writeMacroDiagnostics(e);
    });
  }

  void _assertNonSyntheticElementSelf(Element element) {
    expect(element.isSynthetic, isFalse);
    expect(element.nonSynthetic, same(element));
  }

  void _validateAugmentedInstanceElement(InstanceElementImpl e) {
    InstanceElementImpl? current = e;
    while (current != null) {
      expect(current.augmented, same(e.augmented));
      expect(current.thisType, same(e.thisType));
      switch (e) {
        case ExtensionElementImpl():
          current as ExtensionElementImpl;
          expect(current.extendedType, same(e.extendedType));
        case ExtensionTypeElementImpl():
          current as ExtensionTypeElementImpl;
          expect(current.primaryConstructor, same(e.primaryConstructor));
          expect(current.representation, same(e.representation));
          expect(current.typeErasure, same(e.typeErasure));
      }
      current = current.augmentationTarget;
    }
  }

  void _writeAugmentation(ElementImpl e) {
    if (e case AugmentableElement(:var augmentation?)) {
      _elementPrinter.writeNamedElement('augmentation', augmentation);
    }
  }

  void _writeAugmentationElement(LibraryAugmentationElementImpl e) {
    _writeLibraryOrAugmentationElement(e);
  }

  void _writeAugmentationImportElement(AugmentationImportElementImpl e) {
    var uri = e.uri;
    _sink.writeIndentedLine(() {
      _writeDirectiveUri(e.uri);
    });

    _sink.withIndent(() {
      _writeEnclosingElement(e);
      _writeMetadata(e);
      if (uri is DirectiveUriWithAugmentationImpl) {
        _writeAugmentationElement(uri.augmentation);
      }
    });
  }

  void _writeAugmentationTarget(ElementImpl e) {
    if (e is AugmentableElement && e.isAugmentation) {
      if (e.augmentationTarget case var target?) {
        _elementPrinter.writeNamedElement(
          'augmentationTarget',
          target,
        );
      } else if (e.augmentationTargetAny case var targetAny?) {
        _elementPrinter.writeNamedElement(
          'augmentationTargetAny',
          targetAny,
        );
      }
    }
  }

  void _writeAugmented(InstanceElementImpl e) {
    if (e.augmentationTarget != null) {
      return;
    }

    // No augmentation, not interesting.
    if (e.augmentation == null) {
      expect(e.augmented, TypeMatcher<NotAugmentedInstanceElementImpl>());
      if (!configuration.withAugmentedWithoutAugmentation) {
        return;
      }
    }

    var augmented = e.augmented;

    void writeFields() {
      var sorted = augmented.fields.sortedBy((e) => e.name);
      _elementPrinter.writeElementList('fields', sorted);
    }

    void writeConstructors() {
      if (!configuration.withConstructors) {
        return;
      }
      if (augmented is AugmentedInterfaceElementImpl) {
        var sorted = augmented.constructors.sortedBy((e) => e.name);
        expect(sorted, isNotEmpty);
        _elementPrinter.writeElementList('constructors', sorted);
      }
    }

    void writeAccessors() {
      var sorted = augmented.accessors.sortedBy((e) => e.name);
      _elementPrinter.writeElementList('accessors', sorted);
    }

    void writeMethods() {
      var sorted = augmented.methods.sortedBy((e) => e.name);
      _elementPrinter.writeElementList('methods', sorted);
    }

    _sink.writelnWithIndent('augmented');
    _sink.withIndent(() {
      switch (augmented) {
        case AugmentedClassElement():
          _elementPrinter.writeTypeList('mixins', augmented.mixins);
          _elementPrinter.writeTypeList('interfaces', augmented.interfaces);
          writeFields();
          writeConstructors();
          writeAccessors();
          writeMethods();
        case AugmentedEnumElement():
          _elementPrinter.writeTypeList('mixins', augmented.mixins);
          _elementPrinter.writeTypeList('interfaces', augmented.interfaces);
          writeFields();
          _elementPrinter.writeElementList(
            'constants',
            augmented.constants.sortedBy((e) => e.name),
          );
          writeConstructors();
          writeAccessors();
          writeMethods();
        case AugmentedExtensionElement():
          writeFields();
          writeAccessors();
          writeMethods();
        case AugmentedExtensionTypeElement():
          _elementPrinter.writeTypeList('interfaces', augmented.interfaces);
          writeFields();
          writeConstructors();
          writeAccessors();
          writeMethods();
        case AugmentedMixinElement():
          _elementPrinter.writeTypeList(
            'superclassConstraints',
            augmented.superclassConstraints,
          );
          _elementPrinter.writeTypeList('interfaces', augmented.interfaces);
          writeFields();
          writeAccessors();
          writeMethods();
        default:
          // TODO(scheglov): Add other types and properties
          throw UnimplementedError('${e.runtimeType}');
      }
    });
  }

  void _writeBodyModifiers(ExecutableElement e) {
    if (e.isAsynchronous) {
      expect(e.isSynchronous, isFalse);
      _sink.write(' async');
    }

    if (e.isSynchronous && e.isGenerator) {
      expect(e.isAsynchronous, isFalse);
      _sink.write(' sync');
    }

    _sink.writeIf(e.isGenerator, '*');

    if (e is ExecutableElementImpl && e.invokesSuperSelf) {
      _sink.write(' invokesSuperSelf');
    }
  }

  void _writeCodeRange(Element e) {
    if (configuration.withCodeRanges && !e.isSynthetic) {
      e as ElementImpl;
      _sink.writelnWithIndent('codeOffset: ${e.codeOffset}');
      _sink.writelnWithIndent('codeLength: ${e.codeLength}');
    }
  }

  void _writeConstantInitializer(Element e) {
    if (configuration.withConstantInitializers) {
      if (e is ConstVariableElement) {
        var initializer = e.constantInitializer;
        if (initializer != null) {
          _sink.writelnWithIndent('constantInitializer');
          _sink.withIndent(() {
            _writeNode(initializer);
          });
        }
      }
    }
  }

  void _writeConstructorElement(ConstructorElement e) {
    e as ConstructorElementImpl;

    // Check that the reference exists, and filled with the element.
    var reference = e.reference;
    if (reference == null) {
      fail('Every constructor must have a reference.');
    }

    _sink.writeIndentedLine(() {
      _sink.writeIf(e.isAugmentation, 'augment ');
      _sink.writeIf(e.isSynthetic, 'synthetic ');
      _sink.writeIf(e.isExternal, 'external ');
      _sink.writeIf(e.isConst, 'const ');
      _sink.writeIf(e.isFactory, 'factory ');
      expect(e.isAbstract, isFalse);
      _writeName(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeDisplayName(e);

      var periodOffset = e.periodOffset;
      var nameEnd = e.nameEnd;
      if (periodOffset != null && nameEnd != null) {
        _sink.writelnWithIndent('periodOffset: $periodOffset');
        _sink.writelnWithIndent('nameEnd: $nameEnd');
      }

      _writeParameterElements(e.parameters);

      _writeElements(
        'constantInitializers',
        e.constantInitializers,
        _writeNode,
      );

      var superConstructor = e.superConstructor;
      if (superConstructor != null) {
        var enclosingElement = superConstructor.enclosingElement;
        if (enclosingElement is ClassElement &&
            !enclosingElement.isDartCoreObject) {
          _elementPrinter.writeNamedElement(
            'superConstructor',
            superConstructor,
          );
        }
      }

      var redirectedConstructor = e.redirectedConstructor;
      if (redirectedConstructor != null) {
        _elementPrinter.writeNamedElement(
          'redirectedConstructor',
          redirectedConstructor,
        );
      }

      _writeNonSyntheticElement(e);
      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);
    });

    expect(e.isAsynchronous, isFalse);
    expect(e.isGenerator, isFalse);

    if (e.isSynthetic) {
      expect(e.nameOffset, -1);
      expect(e.nonSynthetic, same(e.enclosingElement));
    } else {
      expect(e.nameOffset, isPositive);
    }
  }

  void _writeDisplayName(Element e) {
    if (configuration.withDisplayName) {
      _sink.writelnWithIndent('displayName: ${e.displayName}');
    }
  }

  void _writeDocumentation(Element element) {
    var documentation = element.documentationComment;
    if (documentation != null) {
      var str = documentation;
      str = str.replaceAll('\n', r'\n');
      str = str.replaceAll('\r', r'\r');
      _sink.writelnWithIndent('documentationComment: $str');
    }
  }

  void _writeEnclosingElement(ElementImpl e) {
    _elementPrinter.writeNamedElement(
      'enclosingElement',
      e.enclosingElement,
    );

    switch (e) {
      case CompilationUnitElementImpl():
        if (identical(e.library.definingCompilationUnit, e)) {
          expect(e.enclosingElement3, isNull);
        } else {
          expect(
            e.enclosingElement3,
            TypeMatcher<CompilationUnitElementImpl>(),
          );
          _elementPrinter.writeNamedElement(
            'enclosingElement3',
            e.enclosingElement3,
          );
        }
      case LibraryImportElementImpl():
      case LibraryExportElementImpl():
      case PartElementImpl():
      case PrefixElementImpl():
        expect(
          e.enclosingElement3,
          TypeMatcher<CompilationUnitElementImpl>(),
        );
        _elementPrinter.writeNamedElement(
          'enclosingElement3',
          e.enclosingElement3,
        );
      default:
        expect(e.enclosingElement3, same(e.enclosingElement));
    }
  }

  void _writeExportNamespace(LibraryElement e) {
    var map = e.exportNamespace.definedNames;
    var sortedEntries = map.entries.sortedBy((entry) => entry.key);
    for (var entry in sortedEntries) {
      _elementPrinter.writeNamedElement(entry.key, entry.value);
    }
  }

  void _writeExtensionElement(ExtensionElementImpl e) {
    _sink.writeIndentedLine(() {
      _sink.writeIf(e.isAugmentation, 'augment ');
      _writeName(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeTypeParameterElements(e.typeParameters);
      if (e.augmentationTarget == null) {
        _writeType('extendedType', e.extendedType);
      }
      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);
      _writeElements('fields', e.fields, _writePropertyInducingElement);
      _writeElements('accessors', e.accessors, _writePropertyAccessorElement);
      _writeMethods(e.methods);
      _validateAugmentedInstanceElement(e);
      _writeAugmented(e);
    });

    _assertNonSyntheticElementSelf(e);
  }

  void _writeFieldFormalParameterField(ParameterElement e) {
    if (e is FieldFormalParameterElement) {
      var field = e.field;
      if (field != null) {
        _elementPrinter.writeNamedElement('field', field);
      } else {
        _sink.writelnWithIndent('field: <null>');
      }
    }
  }

  void _writeFunctionElement(FunctionElementImpl e) {
    expect(e.isStatic, isTrue);

    _sink.writeIndentedLine(() {
      _sink.writeIf(e.isAugmentation, 'augment ');
      _sink.writeIf(e.isExternal, 'external ');
      _writeName(e);
      _writeBodyModifiers(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeTypeParameterElements(e.typeParameters);
      _writeParameterElements(e.parameters);
      _writeReturnType(e.returnType);
      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);
    });

    _assertNonSyntheticElementSelf(e);
  }

  void _writeImportElementPrefix(ImportElementPrefixImpl? prefix) {
    if (prefix != null) {
      _sink.writeIf(prefix is DeferredImportElementPrefix, ' deferred');
      _sink.write(' as ');
      _writeName(prefix.element);
    }
  }

  void _writeInterfaceElement(InterfaceElementImpl e) {
    _sink.writeIndentedLine(() {
      if (e.isAugmentation) {
        _sink.write('augment ');
      }

      switch (e) {
        case ClassElementImpl():
          _sink.writeIf(e.isAbstract, 'abstract ');
          _sink.writeIf(e.isMacro, 'macro ');
          _sink.writeIf(e.isSealed, 'sealed ');
          _sink.writeIf(e.isBase, 'base ');
          _sink.writeIf(e.isInterface, 'interface ');
          _sink.writeIf(e.isFinal, 'final ');
          _writeNotSimplyBounded(e);
          _sink.writeIf(e.isMixinClass, 'mixin ');
          _sink.write('class ');
          _sink.writeIf(e.isMixinApplication, 'alias ');
        case EnumElementImpl():
          _writeNotSimplyBounded(e);
          _sink.write('enum ');
        case ExtensionTypeElementImpl():
          _sink.writeIf(
            e.hasRepresentationSelfReference,
            'hasRepresentationSelfReference ',
          );
          _sink.writeIf(
            e.hasImplementsSelfReference,
            'hasImplementsSelfReference ',
          );
          _writeNotSimplyBounded(e);
        case MixinElementImpl():
          _sink.writeIf(e.isBase, 'base ');
          _writeNotSimplyBounded(e);
          _sink.write('mixin ');
      }

      _writeName(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeTypeParameterElements(e.typeParameters);
      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);

      if (!e.isAugmentation) {
        var supertype = e.supertype;
        if (supertype != null &&
            (supertype.element.name != 'Object' || e.mixins.isNotEmpty)) {
          _writeType('supertype', supertype);
        }
      }

      if (e is ExtensionTypeElementImpl) {
        if (e.augmentationTarget == null) {
          _elementPrinter.writeNamedElement('representation', e.representation);
          _elementPrinter.writeNamedElement(
              'primaryConstructor', e.primaryConstructor);
          _elementPrinter.writeNamedType('typeErasure', e.typeErasure);
        }
      }

      if (e is MixinElementImpl) {
        _elementPrinter.writeTypeList(
          'superclassConstraints',
          e.superclassConstraints,
        );
      }

      _elementPrinter.writeTypeList('mixins', e.mixins);
      _elementPrinter.writeTypeList('interfaces', e.interfaces);

      if (configuration.withAllSupertypes) {
        var sorted = e.allSupertypes.sortedBy((t) => t.element.name);
        _elementPrinter.writeTypeList('allSupertypes', sorted);
      }

      _writeElements('fields', e.fields, _writePropertyInducingElement);

      var constructors = e.constructors;
      if (e is MixinElement) {
        expect(constructors, isEmpty);
      } else if (configuration.withConstructors) {
        _writeElements('constructors', constructors, _writeConstructorElement);
      }

      _writeElements('accessors', e.accessors, _writePropertyAccessorElement);
      _writeMethods(e.methods);

      _validateAugmentedInstanceElement(e);
      _writeAugmented(e);
    });

    _assertNonSyntheticElementSelf(e);
  }

  void _writeLibraryAugmentations(LibraryElementImpl e) {
    if (configuration.withLibraryAugmentations) {
      var augmentations = e.augmentations;
      if (augmentations.isNotEmpty) {
        _sink.writelnWithIndent('augmentations');
        _sink.withIndent(() {
          for (var element in augmentations) {
            _sink.writeIndent();
            _elementPrinter.writeElement(element);
          }
        });
      }
    }
  }

  void _writeLibraryExportElement(LibraryExportElementImpl e) {
    e.location;

    _sink.writeIndentedLine(() {
      _writeDirectiveUri(e.uri);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeMetadata(e);
      _writeNamespaceCombinators(e.combinators);
    });

    _assertNonSyntheticElementSelf(e);
  }

  void _writeLibraryImportElement(LibraryImportElementImpl e) {
    e.location;

    _sink.writeIndentedLine(() {
      _writeDirectiveUri(e.uri);
      _sink.writeIf(e.isSynthetic, ' synthetic');
      _writeImportElementPrefix(e.prefix);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeMetadata(e);
      _writeNamespaceCombinators(e.combinators);
    });
  }

  void _writeLibraryOrAugmentationElement(LibraryOrAugmentationElementImpl e) {
    _writeReference(e);

    if (e is LibraryAugmentationElementImpl) {
      if (e.macroGenerated case var macroGenerated?) {
        _sink.writelnWithIndent('macroGeneratedCode');
        _sink.writeln('---');
        _sink.write(macroGenerated.code);
        _sink.writeln('---');
      }
    }

    _writeDocumentation(e);
    _writeMetadata(e);
    _writeSinceSdkVersion(e);

    if (configuration.withImports) {
      var imports = e.libraryImports.where((import) {
        return configuration.withSyntheticDartCoreImport || !import.isSynthetic;
      }).toList();
      _writeElements(
        'libraryImports',
        imports,
        _writeLibraryImportElement,
      );
      _writeElements('prefixes', e.prefixes, _writePrefixElement);
    }

    _writeElements(
      'libraryExports',
      e.libraryExports,
      _writeLibraryExportElement,
    );

    var definingUnit = e.definingCompilationUnit;
    expect(definingUnit.libraryOrAugmentationElement, same(e));
    if (configuration.filter(definingUnit)) {
      _elementPrinter.writeNamedElement('definingUnit', definingUnit);
    }

    if (e is LibraryElementImpl) {
      _writeLibraryAugmentations(e);
    }

    _writeElements('augmentationImports', e.augmentationImports,
        _writeAugmentationImportElement);
  }

  void _writeMacroDiagnostics(Element e) {
    void writeTypeAnnotationLocation(TypeAnnotationLocation location) {
      switch (location) {
        case AliasedTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('AliasedTypeLocation');
        case ElementTypeLocation():
          _sink.writelnWithIndent('ElementTypeLocation');
          _sink.withIndent(() {
            _elementPrinter.writeNamedElement('element', location.element);
          });
        case ExtendsClauseTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('ExtendsClauseTypeLocation');
        case FormalParameterTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('FormalParameterTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case ListIndexTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('ListIndexTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case RecordNamedFieldTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('RecordNamedFieldTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case RecordPositionalFieldTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('RecordPositionalFieldTypeLocation');
          _sink.withIndent(() {
            _sink.writelnWithIndent('index: ${location.index}');
          });
        case ReturnTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('ReturnTypeLocation');
        case VariableTypeLocation():
          writeTypeAnnotationLocation(location.parent);
          _sink.writelnWithIndent('VariableTypeLocation');
        default:
          // TODO(scheglov): Handle this case.
          throw UnimplementedError('${location.runtimeType}');
      }
    }

    /// Returns `true` if patterns were printed.
    /// Returns `false` if no patterns configured.
    bool printMessagePatterns(String message) {
      var patterns = configuration.macroDiagnosticMessagePatterns;
      if (patterns == null) {
        return false;
      }

      _sink.writelnWithIndent('contains');
      _sink.withIndent(() {
        for (var pattern in patterns) {
          if (message.contains(pattern)) {
            _sink.writelnWithIndent(pattern);
          }
        }
      });
      return true;
    }

    void writeMessage(MacroDiagnosticMessage object) {
      // Write the message.
      if (!printMessagePatterns(object.message)) {
        var message = object.message;
        const stackTraceText = '#0';
        var stackTraceIndex = message.indexOf(stackTraceText);
        if (stackTraceIndex >= 0) {
          var end = stackTraceIndex + stackTraceText.length;
          var withoutStackTrace = message.substring(0, end);
          if (configuration.withMacroStackTraces) {
            _sink.writelnWithIndent('message:\n$message');
          } else {
            _sink.writelnWithIndent('message:\n$withoutStackTrace <cut>');
          }
        } else {
          _sink.writelnWithIndent('message: $message');
        }
      }
      // Write the target.
      var target = object.target;
      switch (target) {
        case ApplicationMacroDiagnosticTarget():
          _sink.writelnWithIndent('target: ApplicationMacroDiagnosticTarget');
          _sink.withIndent(() {
            _sink.writelnWithIndent(
              'annotationIndex: ${target.annotationIndex}',
            );
          });
        case ElementMacroDiagnosticTarget():
          _sink.writelnWithIndent('target: ElementMacroDiagnosticTarget');
          _sink.withIndent(() {
            _elementPrinter.writeNamedElement('element', target.element);
          });
        case ElementAnnotationMacroDiagnosticTarget():
          _sink.writelnWithIndent(
            'target: ElementAnnotationMacroDiagnosticTarget',
          );
          _sink.withIndent(() {
            _elementPrinter.writeNamedElement('element', target.element);
            _sink.writelnWithIndent(
              'annotationIndex: ${target.annotationIndex}',
            );
          });
        case TypeAnnotationMacroDiagnosticTarget():
          _sink.writelnWithIndent(
            'target: TypeAnnotationMacroDiagnosticTarget',
          );
          _sink.withIndent(() {
            writeTypeAnnotationLocation(target.location);
          });
      }
    }

    if (e case MacroTargetElement macroTarget) {
      _sink.writeElements(
        'macroDiagnostics',
        macroTarget.macroDiagnostics,
        (diagnostic) {
          switch (diagnostic) {
            case ArgumentMacroDiagnostic():
              _sink.writelnWithIndent('ArgumentMacroDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _sink.writelnWithIndent(
                  'argumentIndex: ${diagnostic.argumentIndex}',
                );
                _sink.writelnWithIndent('message: ${diagnostic.message}');
              });
            case DeclarationsIntrospectionCycleDiagnostic():
              _sink.writelnWithIndent(
                'DeclarationsIntrospectionCycleDiagnostic',
              );
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _elementPrinter.writeNamedElement(
                  'introspectedElement',
                  diagnostic.introspectedElement,
                );
                _sink.writeElements(
                  'components',
                  diagnostic.components,
                  (component) {
                    _sink.writelnWithIndent(
                      'DeclarationsIntrospectionCycleComponent',
                    );
                    _sink.withIndent(() {
                      _elementPrinter.writeNamedElement(
                        'element',
                        component.element,
                      );
                      _sink.writelnWithIndent(
                        'annotationIndex: ${component.annotationIndex}',
                      );
                      _elementPrinter.writeNamedElement(
                        'introspectedElement',
                        component.introspectedElement,
                      );
                    });
                  },
                );
              });
            case ExceptionMacroDiagnostic():
              _sink.writelnWithIndent('ExceptionMacroDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                if (!printMessagePatterns(diagnostic.message)) {
                  _sink.writelnWithIndent(
                    'message: ${diagnostic.message}',
                  );
                }
                if (configuration.withMacroStackTraces) {
                  _sink.writelnWithIndent(
                    'stackTrace:\n${diagnostic.stackTrace}',
                  );
                }
              });
            case InvalidMacroTargetDiagnostic():
              _sink.writelnWithIndent('InvalidMacroTargetDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _sink.writeElements(
                  'supportedKinds',
                  diagnostic.supportedKinds,
                  (kindName) {
                    _sink.writelnWithIndent(kindName);
                  },
                );
              });
            case MacroDiagnostic():
              _sink.writelnWithIndent('MacroDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent('message: MacroDiagnosticMessage');
                _sink.withIndent(() {
                  writeMessage(diagnostic.message);
                });
                _sink.writeElements(
                  'contextMessages',
                  diagnostic.contextMessages,
                  (message) {
                    _sink.writelnWithIndent('MacroDiagnosticMessage');
                    _sink.withIndent(() {
                      writeMessage(message);
                    });
                  },
                );
                _sink.writelnWithIndent(
                  'severity: ${diagnostic.severity.name}',
                );
                if (diagnostic.correctionMessage case var correctionMessage?) {
                  _sink.writelnWithIndent(
                    'correctionMessage: $correctionMessage',
                  );
                }
              });
            case NotAllowedDeclarationDiagnostic():
              _sink.writelnWithIndent('NotAllowedDeclarationDiagnostic');
              _sink.withIndent(() {
                _sink.writelnWithIndent(
                  'annotationIndex: ${diagnostic.annotationIndex}',
                );
                _sink.writelnWithIndent(
                  'phase: ${diagnostic.phase.name}',
                );
                var nodeRangesStr = diagnostic.nodeRanges
                    .map((r) => '(${r.offset}, ${r.length})')
                    .join(' ');
                _sink.writelnWithIndent('nodeRanges: $nodeRangesStr');
                _sink.writeln('---');
                _sink.write(diagnostic.code);
                _sink.writeln('---');
              });
          }
        },
      );
    }
  }

  void _writeMetadata(Element element) {
    if (configuration.withMetadata) {
      var annotations = element.metadata;
      if (annotations.isNotEmpty) {
        _sink.writelnWithIndent('metadata');
        _sink.withIndent(() {
          for (var annotation in annotations) {
            annotation as ElementAnnotationImpl;
            _writeNode(annotation.annotationAst);
          }
        });
      }
    }
  }

  void _writeMethodElement(MethodElementImpl e) {
    _sink.writeIndentedLine(() {
      _sink.writeIf(e.isAugmentation, 'augment ');
      _sink.writeIf(e.isSynthetic, 'synthetic ');
      _sink.writeIf(e.isStatic, 'static ');
      _sink.writeIf(e.isAbstract, 'abstract ');
      _sink.writeIf(e.isExternal, 'external ');

      _writeName(e);
      _writeBodyModifiers(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeTypeInferenceError(e);

      _writeTypeParameterElements(e.typeParameters);
      _writeParameterElements(e.parameters);
      _writeReturnType(e.returnType);
      _writeNonSyntheticElement(e);
      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);
    });

    if (e.isSynthetic && e.enclosingElement is EnumElementImpl) {
      expect(e.name, 'toString');
      expect(e.nonSynthetic, same(e.enclosingElement));
    } else {
      _assertNonSyntheticElementSelf(e);
    }
  }

  void _writeMethods(List<MethodElementImpl> elements) {
    _writeElements('methods', elements, _writeMethodElement);
  }

  void _writeName(Element e) {
    String name;
    switch (e) {
      case ExtensionElement(name: null):
        name = '<null>';
      default:
        name = e.name!;
    }

    if (e is PropertyAccessorElement && e.isSetter) {
      expect(name, endsWith('='));
    }

    _sink.write(name);
    _sink.write(name.isNotEmpty ? ' @' : '@');
    _sink.write(e.nameOffset);
  }

  void _writeNamespaceCombinator(NamespaceCombinator e) {
    _sink.writeIndentedLine(() {
      if (e is ShowElementCombinator) {
        _sink.write('show: ');
        _sink.write(e.shownNames.join(', '));
      } else if (e is HideElementCombinator) {
        _sink.write('hide: ');
        _sink.write(e.hiddenNames.join(', '));
      }
    });
  }

  void _writeNamespaceCombinators(List<NamespaceCombinator> elements) {
    _writeElements('combinators', elements, _writeNamespaceCombinator);
  }

  void _writeNonSyntheticElement(Element e) {
    if (configuration.withNonSynthetic) {
      _elementPrinter.writeNamedElement('nonSynthetic', e.nonSynthetic);
    }
  }

  void _writeNotSimplyBounded(InterfaceElementImpl e) {
    if (e.isAugmentation) {
      return;
    }
    _sink.writeIf(!e.isSimplyBounded, 'notSimplyBounded ');
  }

  void _writeParameterElement(ParameterElement e) {
    e as ParameterElementImpl;

    if (e.isNamed && e.enclosingElement is ExecutableElement) {
      expect(e.reference, isNotNull);
    } else {
      expect(e.reference, isNull);
    }

    _sink.writeIndentedLine(() {
      if (e.isRequiredPositional) {
        _sink.write('requiredPositional ');
      } else if (e.isOptionalPositional) {
        _sink.write('optionalPositional ');
      } else if (e.isRequiredNamed) {
        _sink.write('requiredNamed ');
      } else if (e.isOptionalNamed) {
        _sink.write('optionalNamed ');
      }

      if (e is ConstVariableElement) {
        _sink.write('default ');
      }

      _sink.writeIf(e.isConst, 'const ');
      _sink.writeIf(e.isCovariant, 'covariant ');
      _sink.writeIf(e.isFinal, 'final ');

      if (e is FieldFormalParameterElement) {
        _sink.write('this.');
      } else if (e is SuperFormalParameterElement) {
        _sink.writeIf(e.hasDefaultValue, 'hasDefaultValue ');
        _sink.write('super.');
      }

      _writeName(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeType('type', e.type);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeTypeParameterElements(e.typeParameters);
      _writeParameterElements(e.parameters);
      _writeConstantInitializer(e);
      _writeNonSyntheticElement(e);
      _writeFieldFormalParameterField(e);
      _writeSuperConstructorParameter(e);
    });
  }

  void _writeParameterElements(List<ParameterElement> elements) {
    _writeElements('parameters', elements, _writeParameterElement);
  }

  void _writePartElement(PartElementImpl e) {
    _sink.writelnWithIndent(_idMap[e]);

    _sink.withIndent(() {
      var uri = e.uri;
      _sink.writeIndentedLine(() {
        _sink.write('uri: ');
        _writeDirectiveUri(e.uri);
      });

      _writeEnclosingElement(e);
      _writeMetadata(e);

      if (uri is DirectiveUriWithUnitImpl) {
        _elementPrinter.writeNamedElement('unit', uri.unit);
      }
    });
  }

  void _writePrefixElement(PrefixElementImpl e) {
    _sink.writeIndentedLine(() {
      _writeName(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
    });
  }

  void _writePropertyAccessorElement(PropertyAccessorElement e) {
    e as PropertyAccessorElementImpl;

    var variable = e.variable2;
    if (variable != null) {
      var variableEnclosing = variable.enclosingElement;
      if (variableEnclosing is CompilationUnitElement) {
        expect(variableEnclosing.topLevelVariables, contains(variable));
      } else if (variableEnclosing is InterfaceElement) {
        expect(variableEnclosing.fields, contains(variable));
      }
    } else {
      expect(e.isAugmentation, isTrue);
      expect(e.augmentationTarget, isNull);
    }

    if (e.isSynthetic) {
      expect(e.nameOffset, -1);
    } else {
      expect(e.nameOffset, isPositive);
      _assertNonSyntheticElementSelf(e);
    }

    _sink.writeIndentedLine(() {
      _sink.writeIf(e.isAugmentation, 'augment ');
      _sink.writeIf(e.isSynthetic, 'synthetic ');
      _sink.writeIf(e.isStatic, 'static ');
      _sink.writeIf(e.isAbstract, 'abstract ');
      _sink.writeIf(e.isExternal, 'external ');

      if (e.isGetter) {
        _sink.write('get ');
      } else {
        _sink.write('set ');
      }

      _writeName(e);
      _writeBodyModifiers(e);
    });

    void writeLinking() {
      if (configuration.withPropertyLinking) {
        _sink.writelnWithIndent('id: ${_idMap[e]}');
        if (e.variable2 case var variable?) {
          _sink.writelnWithIndent('variable: ${_idMap[variable]}');
        } else {
          _sink.writelnWithIndent('variable: <null>');
        }
      }
    }

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);

      expect(e.typeParameters, isEmpty);
      _writeParameterElements(e.parameters);
      _writeReturnType(e.returnType);
      _writeNonSyntheticElement(e);
      writeLinking();
      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);
    });
  }

  void _writePropertyInducingElement(PropertyInducingElement e) {
    e as PropertyInducingElementImpl;

    DartType type = e.type;
    expect(type, isNotNull);

    if (e.isSynthetic) {
      expect(e.nameOffset, -1);
    } else {
      if (!e.isAugmentation) {
        expect(e.getter, isNotNull);
      }

      expect(e.nameOffset, isPositive);
      _assertNonSyntheticElementSelf(e);
    }

    _sink.writeIndentedLine(() {
      _sink.writeIf(e.isAugmentation, 'augment ');
      _sink.writeIf(e.isSynthetic, 'synthetic ');
      _sink.writeIf(e.isStatic, 'static ');
      _sink.writeIf(e is FieldElementImpl && e.isAbstract, 'abstract ');
      _sink.writeIf(e is FieldElementImpl && e.isCovariant, 'covariant ');
      _sink.writeIf(e is FieldElementImpl && e.isExternal, 'external ');
      _sink.writeIf(e.isLate, 'late ');
      _sink.writeIf(e.isFinal, 'final ');
      _sink.writeIf(e.isConst, 'const ');
      if (e is FieldElementImpl) {
        _sink.writeIf(e.isEnumConstant, 'enumConstant ');
        _sink.writeIf(e.isPromotable, 'promotable ');
      }

      _writeName(e);
    });

    void writeLinking() {
      if (configuration.withPropertyLinking) {
        _sink.writelnWithIndent('id: ${_idMap[e]}');

        var getter = e.getter;
        if (getter != null) {
          _sink.writelnWithIndent('getter: ${_idMap[getter]}');
        }

        var setter = e.setter;
        if (setter != null) {
          _sink.writelnWithIndent('setter: ${_idMap[setter]}');
        }
      }
    }

    _sink.withIndent(() {
      _writeReference(e);
      _writeEnclosingElement(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeTypeInferenceError(e);
      _writeType('type', e.type);
      _writeShouldUseTypeForInitializerInference(e);
      _writeConstantInitializer(e);
      _writeNonSyntheticElement(e);
      writeLinking();
      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);
    });
  }

  void _writeReturnType(DartType type) {
    if (configuration.withReturnType) {
      _writeType('returnType', type);
    }
  }

  void _writeShouldUseTypeForInitializerInference(
    PropertyInducingElementImpl e,
  ) {
    if (e.isSynthetic) return;
    if (!e.hasInitializer) return;

    _sink.writelnWithIndent(
      'shouldUseTypeForInitializerInference: '
      '${e.shouldUseTypeForInitializerInference}',
    );
  }

  void _writeSinceSdkVersion(Element e) {
    var sinceSdkVersion = e.sinceSdkVersion;
    if (sinceSdkVersion != null) {
      _sink.writelnWithIndent('sinceSdkVersion: $sinceSdkVersion');
    }
  }

  void _writeSuperConstructorParameter(ParameterElement e) {
    if (e is SuperFormalParameterElement) {
      var superParameter = e.superConstructorParameter;
      if (superParameter != null) {
        _elementPrinter.writeNamedElement(
          'superConstructorParameter',
          superParameter,
        );
      } else {
        _sink.writelnWithIndent('superConstructorParameter: <null>');
      }
    }
  }

  void _writeType(String name, DartType type) {
    _elementPrinter.writeNamedType(name, type);

    if (configuration.withFunctionTypeParameters) {
      if (type is FunctionType) {
        _sink.withIndent(() {
          _writeParameterElements(type.parameters);
        });
      }
    }
  }

  void _writeTypeAliasElement(TypeAliasElement e) {
    e as TypeAliasElementImpl;

    _sink.writeIndentedLine(() {
      _sink.writeIf(e.isAugmentation, 'augment ');
      _sink.writeIf(e.isFunctionTypeAliasBased, 'functionTypeAliasBased ');
      _sink.writeIf(!e.isSimplyBounded, 'notSimplyBounded ');
      _writeName(e);
    });

    _sink.withIndent(() {
      _writeReference(e);
      _writeDocumentation(e);
      _writeMetadata(e);
      _writeSinceSdkVersion(e);
      _writeCodeRange(e);
      _writeTypeParameterElements(e.typeParameters);

      var aliasedType = e.aliasedType;
      _writeType('aliasedType', aliasedType);

      var aliasedElement = e.aliasedElement;
      if (aliasedElement is GenericFunctionTypeElementImpl) {
        _sink.writelnWithIndent('aliasedElement: GenericFunctionTypeElement');
        _sink.withIndent(() {
          _writeTypeParameterElements(aliasedElement.typeParameters);
          _writeParameterElements(aliasedElement.parameters);
          _writeReturnType(aliasedElement.returnType);
        });
      }

      _writeMacroDiagnostics(e);
      _writeAugmentationTarget(e);
      _writeAugmentation(e);
    });

    _assertNonSyntheticElementSelf(e);
  }

  void _writeTypeInferenceError(Element e) {
    TopLevelInferenceError? inferenceError;
    if (e is MethodElementImpl) {
      inferenceError = e.typeInferenceError;
    } else if (e is PropertyInducingElementImpl) {
      inferenceError = e.typeInferenceError;
    }

    if (inferenceError != null) {
      String kindName = inferenceError.kind.toString();
      if (kindName.startsWith('TopLevelInferenceErrorKind.')) {
        kindName = kindName.substring('TopLevelInferenceErrorKind.'.length);
      }
      _sink.writelnWithIndent('typeInferenceError: $kindName');
      _sink.withIndent(() {
        if (kindName == 'dependencyCycle') {
          _sink.writelnWithIndent('arguments: ${inferenceError?.arguments}');
        }
      });
    }
  }

  void _writeTypeParameterElement(TypeParameterElement e) {
    e as TypeParameterElementImpl;

    _sink.writeIndentedLine(() {
      _sink.write('${e.variance.name} ');
      _writeName(e);
    });

    _sink.withIndent(() {
      _writeCodeRange(e);

      var bound = e.bound;
      if (bound != null) {
        _writeType('bound', bound);
      }

      var defaultType = e.defaultType;
      if (defaultType != null) {
        _writeType('defaultType', defaultType);
      }

      _writeMetadata(e);
    });

    _assertNonSyntheticElementSelf(e);
  }

  void _writeTypeParameterElements(List<TypeParameterElement> elements) {
    _writeElements('typeParameters', elements, _writeTypeParameterElement);
  }

  void _writeUnitElement(CompilationUnitElementImpl e) {
    _writeEnclosingElement(e);

    if (configuration.withImports) {
      var imports = e.libraryImports.where((import) {
        return configuration.withSyntheticDartCoreImport || !import.isSynthetic;
      }).toList();
      _writeElements('libraryImports', imports, _writeLibraryImportElement);
    }
    _writeElements(
      'libraryImportPrefixes',
      e.libraryImportPrefixes,
      _writePrefixElement,
    );
    _writeElements(
        'libraryExports', e.libraryExports, _writeLibraryExportElement);
    _writeElements('parts', e.parts, _writePartElement);

    _writeElements('classes', e.classes, _writeInterfaceElement);
    _writeElements('enums', e.enums, _writeInterfaceElement);
    _writeElements('extensions', e.extensions, _writeExtensionElement);
    _writeElements(
      'extensionTypes',
      e.extensionTypes,
      _writeInterfaceElement,
    );
    _writeElements('mixins', e.mixins, _writeInterfaceElement);
    _writeElements('typeAliases', e.typeAliases, _writeTypeAliasElement);
    _writeElements(
      'topLevelVariables',
      e.topLevelVariables,
      _writePropertyInducingElement,
    );
    _writeElements(
      'accessors',
      e.accessors,
      _writePropertyAccessorElement,
    );
    _writeElements('functions', e.functions, _writeFunctionElement);
  }
}

class _IdMap {
  final Map<Element, String> fieldMap = Map.identity();
  final Map<Element, String> getterMap = Map.identity();
  final Map<Element, String> partMap = Map.identity();
  final Map<Element, String> setterMap = Map.identity();

  String operator [](Element element) {
    if (element is FieldElement) {
      return fieldMap[element] ??= 'field_${fieldMap.length}';
    } else if (element is TopLevelVariableElement) {
      return fieldMap[element] ??= 'variable_${fieldMap.length}';
    } else if (element is PropertyAccessorElement && element.isGetter) {
      return getterMap[element] ??= 'getter_${getterMap.length}';
    } else if (element is PartElementImpl) {
      return partMap[element] ??= 'part_${partMap.length}';
    } else if (element is PropertyAccessorElement && element.isSetter) {
      return setterMap[element] ??= 'setter_${setterMap.length}';
    } else {
      return '???';
    }
  }
}
