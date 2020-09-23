clear;
clc;

[FileName, FilePath] = uigetfile('*.mat');
File = fullfile(FilePath, FileName);
load(File);

raw = vertcat(ch_12,ch_13,ch_14,ch_15,ch_16,ch_17,ch_21,ch_22,ch_23,ch_24,ch_25,ch_26,ch_27,ch_28,ch_31,ch_32,ch_33,ch_34,ch_35,ch_36,ch_37,ch_38,ch_41,ch_42,ch_43,ch_44,ch_45,ch_46,ch_47,ch_48,ch_51,ch_52,ch_53,ch_54,ch_55,ch_56,ch_57,ch_58,ch_61,ch_62,ch_63,ch_64,ch_65,ch_66,ch_67,ch_68,ch_71,ch_72,ch_73,ch_74,ch_75,ch_76,ch_77,ch_78,ch_82,ch_83,ch_84,ch_85,ch_86,ch_87);

