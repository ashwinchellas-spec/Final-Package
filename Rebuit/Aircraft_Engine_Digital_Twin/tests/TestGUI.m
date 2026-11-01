function tests = TestGUI
%TESTGUI Optional real eight-tab walkthrough and warning capture; never a static mockup.
tests=functiontests(localfunctions);
end
function testEightTabsAndKaveriWarning(testCase)
assumeTrue(testCase,usejava('desktop'),'MATLAB desktop unavailable; GUI walkthrough NOT EXECUTED.');
[db,file]=new_test_database(); delete(db); app=EngineAnalyser_v1(file);
cleanup=onCleanup(@() close_app_fixture(app,file));
verifyEqual(testCase,numel(app.Controls.TabGroup.Children),8);
app.Controls.Engine.Value=8; gui_action(app,'engine'); gui_action(app,'physics');
verifyTrue(testCase,contains(app.Controls.Banner.Text,'NOT MANUFACTURER-CONFIRMED'));
verifyFalse(testCase,isempty(app.Controls.Metrics.Data));
p=project_paths(); folder=fullfile(p.reports,'gui_walkthrough'); if ~isfolder(folder), mkdir(folder); end
tabs=app.Controls.TabGroup.Children;
for i=1:numel(tabs)
    app.Controls.TabGroup.SelectedTab=tabs(i); drawnow;
    exportapp(app.UIFigure,fullfile(folder,sprintf('tab_%d.png',i)));
end
end
function close_app_fixture(app,file)
%CLOSE_APP_FIXTURE Release GUI and DB before removing the fixture database.
delete(app); delete(file);
end
