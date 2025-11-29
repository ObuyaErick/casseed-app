import 'package:casseed/models/entities/described.dart';
import 'package:casseed/models/entities/identified.dart';
import 'package:casseed/models/entities/named.dart';

abstract class Entity implements Identified, Named, Described {}
