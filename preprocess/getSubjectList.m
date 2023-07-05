function list_subjects = getSubjectList(data_dir)
%getSubjectList - 実験データの読み込み
%
% data_dirに保存されている実験データから実験マウスリストを取得する
%
% [書式]
%　　list_subjects = getSubjectList(data_dir)
%
%
% [入力]
%　　data_dir: 実験データが格納されているフォルダ名（文字列）
%
% [出力]
%   list_subjects: 実験マウスリストを格納したセル配列
%
%=========================================================================


subfolders = dir(data_dir);
MaxSF = length(subfolders);
list_subjects = cell(1, MaxSF);
idx = 0;
for n = 1:MaxSF
    folder_name = subfolders(n).name;
    if ~startsWith(folder_name, '.') && subfolders(n).isdir
        idx = idx+1;
        list_subjects{idx} = folder_name;
    end
end
list_subjects(idx+1:end) = [];
end