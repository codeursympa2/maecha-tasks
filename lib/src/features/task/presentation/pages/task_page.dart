import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:maecha_tasks/src/constants/colors/light_mode/light_mode_colors.dart';
import 'package:maecha_tasks/src/constants/numbers.dart';
import 'package:maecha_tasks/src/constants/strings/form_strings.dart';
import 'package:maecha_tasks/src/constants/strings/strings.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/task_priority.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/bottom_nav_bloc/bottom_nav_bar_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/bloc/task_bloc/task_bloc.dart';
import 'package:maecha_tasks/src/features/task/presentation/utils/utils.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/form_widgets.dart';
import 'package:maecha_tasks/src/utils/easy_loading_messages.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if(state is TaskLoadingState){
          showCustomMessage(message: waiting);
        }

        if(state is TaskCreateSuccessState){
          showCustomSuccess(message: state.message);
          BlocProvider.of<BottomNavBarBloc>(context).add(
              const GoToPageEvent(pathName: "task-list"));
        }

        if(state is TitleExistState){
          showCustomError(message: state.message);
        }

        if(state is TaskFailureState){
          showCustomError(message: state.message);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(paddingPagesApp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(createTask,style: Theme.of(context).textTheme.displayLarge,),
            const Gap(16),
            Text(descCreateTask,style: Theme.of(context).textTheme.titleMedium,),
            const Gap(16),
            const _TaskForm()
          ],),
        ),
      ),
),
    );
  }
}

class _TaskForm extends StatefulWidget {
  const _TaskForm({super.key});

  @override
  State<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<_TaskForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  //names fields
  final String titleName="title";
  final String descName="desc";
  final String hourName="hour";
  final String dateName="date";

  //Controllers fields
  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _descController=TextEditingController();
  final TextEditingController _hourController=TextEditingController();
  final TextEditingController _dateController=TextEditingController();

  //
  final FocusNode _titleFocusNode=FocusNode();
  final FocusNode _descFocusNode=FocusNode();
  final FocusNode _hourFocusNode=FocusNode();
  final FocusNode _dateFocusNode=FocusNode();

  //
  bool _notificationsEnabled = false;
  //


  void _onChangedNotifyValue(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
    listener: (context, state) {
      if(state is TaskCreateSuccessState){

      }
    },
  child: FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          _buildTitleField(),
          const Gap(16),
          Row(children: [
            Expanded(child: _buildDateField()),
            const Gap(4),
            Expanded(child: _buildHourField()),
          ],),
          const Gap(16),
          _buildDescField(),
          const Gap(16),
          _buildColorChoice(),
          const Gap(16),
          SwitchListTile(
            tileColor: backgroundLight,
            activeColor: primaryLight,
            contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            title: Text("Activer les notifications pour cette tâche",style: Theme.of(context).textTheme.labelSmall,),
            value: _notificationsEnabled,
            onChanged:_onChangedNotifyValue,
          ),
          const Gap(16),
          ElevatedButton(
            onPressed: (){
              if((_formKey.currentState?.saveAndValidate() ?? false)){
                _logicToCreate();
              }
            },
            child: Text('Ajouter une tâche'),
          ),
        ],
      ),
    ),
);

  }

  Widget _buildTitleField(){
    return  formBuilderTextField(
        formKey: _formKey,
        context: context,
        ctrl: _titleController,
        label: "Titre",
        textInputAction: TextInputAction.next,
        focusNode:  _titleFocusNode,
        name: "title",
        focused: true,
        validators: [
          requiredFieldForm(),
          FormBuilderValidators.minLength( 3, errorText: 'Le titre doit comporter au moins 3 caractères'),
        ]
    );
  }
  Widget _buildDescField(){
    return  formBuilderTextField(
        formKey: _formKey,
        context: context,
        ctrl: _descController,
        label: "Description",
        textInputAction: TextInputAction.next,
        focusNode:  _descFocusNode,
        name: descName,
        maxLines: 4,
        validators: [
          requiredFieldForm()
        ]
    );
  }
  Widget _buildDateField(){
    return  FormBuilderDateTimePicker(
      name: dateName,
      controller: _dateController,
      focusNode: _dateFocusNode,
      initialEntryMode: DatePickerEntryMode.calendar,
      inputType: InputType.date,
      decoration: const InputDecoration(
        labelText: 'Date',
      ),
      validator: FormBuilderValidators.compose([
        requiredFieldForm()
      ]),
    );
  }
  Widget _buildHourField(){
    return FormBuilderDateTimePicker(
      name: hourName,
      controller: _hourController,
      initialEntryMode: DatePickerEntryMode.calendar,
      inputType: InputType.time,
      focusNode: _hourFocusNode,
      decoration: const InputDecoration(
        labelText: 'Heure',
      ),
      validator: FormBuilderValidators.compose([
        requiredFieldForm()
      ]),
    );
  }
  Widget _buildColorChoice(){
    return  FormBuilderChoiceChip<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      backgroundColor: backgroundLight,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      spacing: 3,
      decoration: const InputDecoration(
          labelText:
          'Priorités'),
      name: 'priority',
      initialValue: lowValue,
      options:   const [
        FormBuilderChipOption(
          value: lowValue,
          avatar: const CircleAvatar(
              backgroundColor: Colors.orange,
              foregroundColor: backgroundLight,
              child:  Text('B'),
          ),
        ),
        FormBuilderChipOption(
          value: mediumValue,
          avatar: CircleAvatar(child: Text('M')),
        ),
        FormBuilderChipOption(
          value: highValue,
          avatar: CircleAvatar(child: Text('E')),
        ),
      ],
      onChanged: _onChanged,
    );
  }

  void _onChanged(dynamic val) => debugPrint(val.toString());

  TaskPriority _convertFormValuePriority(String value){
    late TaskPriority vl;
    switch(value){
      case lowValue:
        vl=TaskPriority.low;
      case highValue :
        vl=TaskPriority.high;
      case mediumValue :
      vl=TaskPriority.medium;
    }

    return vl;
  }

  _logicToCreate() {
    final formValues=_formKey.currentState?.value;

    TaskModel task=TaskModel.addTask(
        title: formValues!['title'],
        desc: formValues['desc'],
        dateTime: combineDateAndTime(formValues['date'].toString(), formValues['hour'].toString()),
        priority: _convertFormValuePriority(formValues['priority'].toString()),
        notify: _notificationsEnabled,
        done: false
    );
    //BlocProvider.of<TaskBloc>(context).add(CreateTaskRemoteEvent(task: task));
    BlocProvider.of<TaskBloc>(context).add(CreateTaskLocaleEvent(task: task));
  }


}