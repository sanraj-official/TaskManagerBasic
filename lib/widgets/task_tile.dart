import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:task_manager_basic/Utils/custom_decoration.dart';
import '../models/task_model.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskTile({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6,vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 5),
        decoration: BoxDecoration(
          gradient: widget.task.isCompleted
              ?  LinearGradient(
                  colors: [ const Color(0XFF9C4EDC), const Color(0xFF5D80E1).withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [const Color(0XFFD91818).withOpacity(0.8), const Color(0XFFFF4040).withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          // color: widget.task.isCompleted ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset:  Offset(0, 2),
            ),
          ],
          border: Border.all(
            color:  widget.task.isCompleted
                ? const Color(0XFF9C4EDC)
                : const  Color(0XFFD91818),// Border color
            width: 1.5,        // Border width
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(
                    color: Colors.black54, // Border color
                    width: 1.5,       // Border width
                  ),
                  activeColor: Colors.yellowAccent,
                  checkColor: Colors.redAccent,
                  value: widget.task.isCompleted,
                  onChanged: (_) => widget.onToggle(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20, // Adjust height as needed
                        child: (widget.task.title.length > 45)
                            ? Marquee(
                          text: widget.task.title,
                          velocity: 30.0,
                          blankSpace: 40.0,
                          pauseAfterRound: const Duration(seconds: 1),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        )
                            : Text(
                          widget.task.title,
                          style: TextStyle(
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.bold,
                            decoration: widget.task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.task.description ?? '',
                        style: const TextStyle(color: Colors.greenAccent),
                        maxLines: _isExpanded ? null : 2,
                        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 'edit') {
                      widget.onEdit();
                    } else if (value == 'delete') {
                      widget.onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            Text("Created at: ${CustomDecoration.dateTimeFormatterView(widget.task.createdAt)}",
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
