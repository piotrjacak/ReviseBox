// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashcardSetAdapter extends TypeAdapter<FlashcardSet> {
  @override
  final int typeId = 0;

  @override
  FlashcardSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashcardSet(
      id: fields[0] as int,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      finished: fields[3] as bool,
      favourite: fields[4] as bool,
      cards: (fields[5] as List).cast<Flashcard>(),
    );
  }

  @override
  void write(BinaryWriter writer, FlashcardSet obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.finished)
      ..writeByte(4)
      ..write(obj.favourite)
      ..writeByte(5)
      ..write(obj.cards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashcardSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
