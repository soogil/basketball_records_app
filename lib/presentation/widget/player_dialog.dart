import 'package:basketball_records/core/theme/br_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for TextInputFormatter
import 'package:basketball_records/data/model/player_model.dart';

class PlayerDialog extends StatefulWidget {
  final List<PlayerModel> allPlayers;
  final Function(List<TeamInput>) onSave;

  const PlayerDialog({
    super.key,
    required this.allPlayers,
    required this.onSave,
  });

  @override
  State<PlayerDialog> createState() => _PlayerDialogState();
}

class _PlayerDialogState extends State<PlayerDialog> {
  List<PlayerModel> availablePlayers = [];
  List<List<PlayerGameInput>> teams = [[], []];
  List<TeamMeta> teamMetas = [TeamMeta(), TeamMeta()];
  int selectedTeam = 0;

  @override
  void initState() {
    super.initState();
    availablePlayers = List.from(widget.allPlayers)
      ..sort((a, b) => a.name.compareTo(b.name));

    for (int i = 0; i < teamMetas.length; i++) {
      _bindTeamInputListeners(i);
    }
  }

  void addTeam() {
    if (teams.length < 3) {
      setState(() {
        teams.add([]);
        teamMetas.add(TeamMeta());
        _bindTeamInputListeners(teams.length - 1);
      });
    }
  }

  void removeTeam(int idx) {
    setState(() {
      availablePlayers.addAll(teams[idx].map((e) => e.player));
      teams.removeAt(idx);
      teamMetas[idx].dispose();
      teamMetas.removeAt(idx);
      if (selectedTeam >= teams.length) selectedTeam = 0;
      availablePlayers.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void selectTeam(int idx) {
    setState(() {
      selectedTeam = idx;
    });
  }

  void movePlayerToTeam(PlayerModel player) {
    if (!availablePlayers.contains(player)) return;
    setState(() {
      availablePlayers.remove(player);
      final playerInput = PlayerGameInput(player: player);
      final meta = teamMetas[selectedTeam];
      playerInput.gamesController.text = meta.gamesController.text;
      playerInput.winsController.text = meta.winsController.text;
      playerInput.scoreController.text = meta.scoreController.text;
      teams[selectedTeam].add(playerInput);
    });
  }

  void removePlayerFromTeam(PlayerGameInput playerInput, int teamIdx) {
    setState(() {
      teams[teamIdx].remove(playerInput);
      availablePlayers.add(playerInput.player);
      availablePlayers.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _bindTeamInputListeners(int teamIdx) {
    final meta = teamMetas[teamIdx];

    meta.gamesController.addListener(() {
      final games = meta.gamesController.text;
      for (var player in teams[teamIdx]) {
        player.gamesController.text = games;
      }
    });
    meta.winsController.addListener(() {
      final wins = meta.winsController.text;
      for (var player in teams[teamIdx]) {
        player.winsController.text = wins;
      }
    });
    meta.scoreController.addListener(() {
      final score = meta.scoreController.text;
      for (var player in teams[teamIdx]) {
        player.scoreController.text = score;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < teams.length; i++)
                  Expanded(
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: i == 0 ? Radius.circular(10) : Radius.zero,
                          topLeft: i == 0 ? Radius.circular(10) : Radius.zero,
                          bottomRight: i == teams.length - 1 ? Radius.circular(10) : Radius.zero,
                          topRight: i == teams.length - 1 ? Radius.circular(10) : Radius.zero,
                        ),
                      ),
                      onTap: () => selectTeam(i),
                      tileColor: selectedTeam == i ? BRColors.greenCf : BRColors.greyDa,
                      title: InkWell(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('팀 ${i + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 50,
                                      child: TextField(
                                        decoration: InputDecoration(labelText: "경기", isDense: true),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: teamMetas[i].gamesController,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 50,
                                      child: TextField(
                                        decoration: InputDecoration(labelText: "승", isDense: true),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: teamMetas[i].winsController,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 50,
                                      child: TextField(
                                        decoration: InputDecoration(labelText: "승점", isDense: true),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: teamMetas[i].scoreController,
                                      ),
                                    ),
                                    if (teams.length == 3 && i == 2)
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => removeTeam(i),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  spacing: 8,
                                  children: teams[i].map(
                                        (playerInput) => _playerDetail(playerInput, i, onUpdate: () => setState(() {})),
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (teams.length < 3)
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addTeam,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 5),
          Text("아래에서 선수를 선택해 팀에 추가하세요"),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availablePlayers
                .map(
                  (player) => ActionChip(
                label: Text(player.name),
                onPressed: () => movePlayerToTeam(player),
              ),
            )
                .toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final teamInputs = List<TeamInput>.generate(
                teams.length,
                    (i) => TeamInput(
                  teamName: '팀 ${i + 1}',
                  players: teams[i],
                ),
              );
              widget.onSave(teamInputs);
            },
            child: Text('저장'),
          ),
        ],
      ),
    );
  }

  Widget _playerDetail(PlayerGameInput input, int index, {required VoidCallback onUpdate}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(input.player.name, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 15),
            SizedBox(
              width: 55,
              child: DropdownButton<int>(
                value: input.attendanceScore,
                isExpanded: true,
                items: [
                  DropdownMenuItem(value: 10, child: Text("참석")),
                  DropdownMenuItem(value: 5, child: Text("조퇴")),
                  DropdownMenuItem(value: -5, child: Text("노쇼")),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      input.attendanceScore = v;
                    });
                    onUpdate();
                  }
                },
                underline: SizedBox(),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: TextField(
                decoration: InputDecoration(labelText: '경기', isDense: true),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: input.gamesController,
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 40,
              child: TextField(
                decoration: InputDecoration(labelText: '승리', isDense: true),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: input.winsController,
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 45,
              child: TextField(
                decoration: InputDecoration(labelText: '승점', isDense: true),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: input.scoreController,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 18),
              padding: EdgeInsets.zero,
              onPressed: () => removePlayerFromTeam(input, index),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerGameInput {
  final PlayerModel player;
  int games;
  double wins;
  int score;
  final TextEditingController gamesController;
  final TextEditingController winsController;
  final TextEditingController scoreController;
  int attendanceScore;
  PlayerGameInput({
    required this.player,
    this.games = 0,
    this.wins = 0,
    this.score = 0,
    this.attendanceScore = 10,
  })  : gamesController = TextEditingController(),
        winsController = TextEditingController(),
        scoreController = TextEditingController();

  void dispose() {
    gamesController.dispose();
    winsController.dispose();
    scoreController.dispose();
  }
}

// TeamInput 데이터 모델
class TeamInput {
  final String teamName;
  final List<PlayerGameInput> players;
  TeamInput({required this.teamName, required this.players});
}

class TeamMeta {
  final TextEditingController gamesController;
  final TextEditingController winsController;
  final TextEditingController scoreController;
  TeamMeta()
      : gamesController = TextEditingController(),
        winsController = TextEditingController(),
        scoreController = TextEditingController();

  void dispose() {
    gamesController.dispose();
    winsController.dispose();
    scoreController.dispose();
  }
}
