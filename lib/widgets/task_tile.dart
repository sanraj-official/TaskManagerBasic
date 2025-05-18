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
                PopupMenuButton<Menu>(
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == Menu.edit) {
                      widget.onEdit();
                    } else if (value == Menu.delete) {
                      widget.onDelete();
                    }
                    else if (value == Menu.viewLogs) {
                      _showTaskDetails(context, widget.task);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: Menu.edit, child: Text('Edit')),
                    PopupMenuItem(value: Menu.delete, child: Text('Delete')),
                    PopupMenuItem(value: Menu.viewLogs, child: Text('View Logs')),
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

  void _showTaskDetails(BuildContext context, Task task) {
    final ScrollController scrollController = ScrollController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding:  const EdgeInsets.only(top: 8,bottom: 8,right: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row with Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 5,),
                    const Text(
                      "Task Details",
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context,rootNavigator: true).pop(),
                    ),
                  ],
                ),
                const Divider(),
                // Scrollable Content
                Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 12,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding:  const EdgeInsets.only(right: 16,left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.description ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Colors.black87
                              ),
                            ),
                            task.description !=null && task.description!.isNotEmpty? const SizedBox(height: 8):Container(),

                            getUpdateLog(task)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget getUpdateLog(Task task){
    Widget basicInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Created at: ${CustomDecoration.dateTimeFormatterView(task.createdAt)}",
          style: const TextStyle(color: Colors.black45),
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
        Text(
          "Completed : ${task.isCompleted ? "Yes" : "No"}",
          style: const TextStyle(color: Colors.black45),
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
        task.isCompleted?Text(
          "Completed at : ${task.completedAt != null ? CustomDecoration.dateTimeFormatterView(task.completedAt!) : "Not Completed"}",
          style: const TextStyle(color: Colors.black45),
          maxLines: null,
          overflow: TextOverflow.visible,
        ):Container(),
        Text("Updated : ${task.updatedAt.isEmpty ? "Never" : task.updatedAt.length > 1 ? "${task.updatedAt.length} times" : "Once"}",
          style: const TextStyle(color: Colors.black45),
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
      ],
    );
    if(task.updatedAt.isEmpty){
      return  basicInfo ;
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          basicInfo,
          const SizedBox(height: 8),
          const Text(
            "Updated on",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: task.updatedAt.length,
            itemBuilder: (context, index) {
              return Text(
                "${index + 1}.>  ${CustomDecoration.dateTimeFormatterView(task.updatedAt[index])}",
                style: const TextStyle(color: Colors.black45),
              );
            },
          ),
        ],
      );
    }

  }
}
enum Menu{
  edit,
  delete,
  viewLogs,
}
