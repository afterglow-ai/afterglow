import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sendream/main.dart';
import 'package:sendream/pages/chat_page.dart';
import 'package:sendream/pages/memory_page.dart';

GlobalKey<NavPageState> navPageKey = GlobalKey<NavPageState>();

GlobalKey<ChatPageState> chatPageKey = GlobalKey<ChatPageState>();
GlobalKey<MemoryPageState> memKey = GlobalKey<MemoryPageState>();

AudioPlayer player = AudioPlayer();
