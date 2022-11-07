import 'package:fluent_ui/fluent_ui.dart';

import '../../../auth/employee/employee_model.dart';
import '../../../widgets/text_icon.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.isSmall,
    required this.employee,
  });

  final bool isSmall;
  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isSmall ? double.infinity : null,
      child: Card(
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : ' ',
              ),
            ),
            TextIcon.selectable(
              text: employee.name,
              icon: FluentIcons.user_sync,
              margin: const EdgeInsets.only(top: 8),
            ),
            TextIcon.selectable(
              text: employee.email,
              icon: FluentIcons.mail,
            ),
            Chip(
              text: Text(
                employee.role.toUpperCase(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
