import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Nat "mo:base/Nat";
import Bool "mo:base/Bool";
import Text "mo:base/Text";

import Type "Types";

actor class Homework() {
  type Homework = Type.Homework;

  let homeworkDiary = Buffer.Buffer<Homework>(2);

  public shared func addHomework(homework : Homework) : async Nat {
    homeworkDiary.add(homework);
    return (homeworkDiary.size());
  };

  public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
    let size = homeworkDiary.size();
    if (id >= size) {
      return #err("Not a Homework");
    } else {
      return #ok(homeworkDiary.get(id));
    };

  };

  public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
    let size = homeworkDiary.size();
    if (id >= size) {
      return #err("Not a Homework");
    } else {
      homeworkDiary.put(id, homework);
      return #ok();
    };

  };

  public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
    var found = homeworkDiary.getOpt(id);
    switch (found) {
      case null return #err "Not a Homework";
      case (?found) {
        var clone : Homework = {
          title = found.title;
          description = found.description;
          dueDate = found.dueDate;
          completed = true;
        };
        homeworkDiary.put(id, clone);
        return #ok;
      };
    };
  };

  public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
    let size = homeworkDiary.size();
    if (id >= size) {
      return #err("Not a Homework");
    } else {
      let x = homeworkDiary.remove(id);
      return #ok();
    };
  };

  public shared query func getAllHomework() : async [Homework] {
    return (Buffer.toArray(homeworkDiary));

  };

  public shared query func getPendingHomework() : async [Homework] {
    var counter : Nat = 0;
    let pendingHomeworks = Buffer.Buffer<Homework>(2);
    for (homework in homeworkDiary.vals()) {
      var completedCheck = homework.completed;
      if (completedCheck == false) {
        pendingHomeworks.add(homework);
      };
      counter += 1;
    };
    return (Buffer.toArray(pendingHomeworks));
  };

  public shared query func searchHomework(searchTerm : Text) : async [Homework] {
    var counter : Nat = 0;
    let queryHomeworks = Buffer.Buffer<Homework>(2);
    for (homework in homeworkDiary.vals()) {
      var titleCheck = homework.title;
      var descriptionCheck = homework.description;
      if (titleCheck == searchTerm) {
        queryHomeworks.add(homework);
      };
      if (descriptionCheck == searchTerm) {
        queryHomeworks.add(homework);
      };
      counter += 1;
    };
    return (Buffer.toArray(queryHomeworks));
  };

};
