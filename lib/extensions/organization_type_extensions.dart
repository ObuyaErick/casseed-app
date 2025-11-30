import 'package:flutter/material.dart';
import 'package:casseed/models/auth/organization_type.enum.dart';

extension OrganizationTypeExtension on OrganizationType {
  String get label {
    switch (this) {
      case OrganizationType.farmer:
        return 'Farmer';
      case OrganizationType.supplier:
        return 'Supplier';
      case OrganizationType.processor:
        return 'Processor';
      case OrganizationType.distributor:
        return 'Distributor';
      case OrganizationType.retailer:
        return 'Retailer';
      case OrganizationType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case OrganizationType.farmer:
        return Icons.agriculture;
      case OrganizationType.supplier:
        return Icons.local_shipping;
      case OrganizationType.processor:
        return Icons.factory;
      case OrganizationType.distributor:
        return Icons.warehouse;
      case OrganizationType.retailer:
        return Icons.storefront;
      case OrganizationType.other:
        return Icons.business;
    }
  }
}
